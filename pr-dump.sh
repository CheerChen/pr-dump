#!/bin/bash

# ==============================================================================
# Script: pr-dump.sh (v0.1.0)
# Description: Dumps all GitHub Pull Request context (metadata, comments, and 
#              diff) into a single text file for LLM review.
#
# Usage: ./pr-dump.sh [OPTIONS] <PR_NUMBER>
#
# Requirements:
#   - gh (GitHub CLI): Authenticated with `gh auth login`.
#   - jq: A command-line JSON processor.
#   - git: Must be inside the repository's directory.
# ==============================================================================

VERSION="0.1.1"

# Default values
OUTPUT_FILE="review.txt"
OUTPUT_FORMAT="text"
VERBOSE=false

# --- Helper Functions ---

show_help() {
    cat << EOF
pr-dump - Dump GitHub PR context for LLM review

USAGE:
    pr-dump [OPTIONS] <PR_NUMBER>

OPTIONS:
    -o, --output FILE       Output file name (default: review.txt)
    -f, --format FORMAT     Output format: text, markdown (default: text)
    -v, --verbose           Show detailed progress information
    -h, --help              Show this help message
    --version               Show version information

EXAMPLES:
    pr-dump 123                    # Basic usage
    pr-dump -o pr123.txt 123       # Custom output file
    pr-dump -f markdown 123        # Markdown format
    pr-dump -v --output pr.md 123  # Verbose with custom output

REQUIREMENTS:
    - gh (GitHub CLI) - authenticated
    - jq (JSON processor)
    - git repository (run from repo directory)

For more information, visit: https://github.com/CheerChen/pr-dump
EOF
}

show_version() {
    echo "pr-dump version $VERSION"
}

log_info() {
    if [ "$VERBOSE" = true ]; then
        echo "   - $1"
    fi
}

log_error() {
    echo "❌ Error: $1" >&2
}

log_success() {
    echo "✅ $1"
}

# --- Argument Parsing ---

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --version)
            show_version
            exit 0
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -f|--format)
            OUTPUT_FORMAT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -*)
            log_error "Unknown option: $1"
            echo "Use --help for usage information."
            exit 1
            ;;
        *)
            if [ -z "$PR_NUMBER" ]; then
                PR_NUMBER="$1"
            else
                log_error "Multiple PR numbers provided. Only one is allowed."
                exit 1
            fi
            shift
            ;;
    esac
done

# --- Validation ---

# Check for required commands
if ! command -v gh &> /dev/null; then
    log_error "'gh' (GitHub CLI) is not installed. Please install it to continue."
    echo "Install: https://cli.github.com/"
    exit 1
fi
if ! command -v jq &> /dev/null; then
    log_error "'jq' is not installed. Please install it to continue."
    echo "Install: https://jqlang.github.io/jq/"
    exit 1
fi

# Check GitHub CLI authentication status
log_info "Checking GitHub CLI authentication..."
if ! gh auth status &> /dev/null; then
    log_error "GitHub CLI is not authenticated."
    echo "Please authenticate with GitHub CLI first:"
    echo "  gh auth login"
    echo ""
    echo "Or check your authentication status:"
    echo "  gh auth status"
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir &> /dev/null; then
    log_error "Not in a Git repository."
    echo "Please run this command from inside a Git repository directory."
    echo ""
    echo "If this is your first time:"
    echo "  cd /path/to/your/repository"
    echo "  pr-dump <PR_NUMBER>"
    exit 1
fi

# Check for PR number argument
if [ -z "$PR_NUMBER" ]; then
    log_error "PR number is required."
    echo
    show_help
    exit 1
fi

# Validate PR number is numeric
if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
    log_error "PR number must be a positive integer."
    exit 1
fi

# Validate output format
if [[ "$OUTPUT_FORMAT" != "text" && "$OUTPUT_FORMAT" != "markdown" ]]; then
    log_error "Invalid format '$OUTPUT_FORMAT'. Supported formats: text, markdown"
    exit 1
fi

echo "🚀 Starting context generation for PR #${PR_NUMBER}..."
log_info "Output file: $OUTPUT_FILE"
log_info "Output format: $OUTPUT_FORMAT"

# --- 2. Fetch PR Information ---

log_info "Fetching PR metadata (owner, repo, base branch, head ref)..."
PR_INFO=$(gh pr view "$PR_NUMBER" --json headRepositoryOwner,headRepository,baseRefName,headRefName,headRefOid 2>&1)

# Check for specific error cases
if echo "$PR_INFO" | grep -q "pull request not found" 2>/dev/null; then
    log_error "Pull request #${PR_NUMBER} not found."
    echo "Please check:"
    echo "  - PR number is correct"
    echo "  - You're in the correct repository directory"
    echo "  - The PR exists and is accessible"
    exit 1
elif echo "$PR_INFO" | grep -q "authentication" 2>/dev/null; then
    log_error "GitHub authentication failed."
    echo "Please re-authenticate with GitHub CLI:"
    echo "  gh auth login"
    exit 1
elif [ -z "$PR_INFO" ] || echo "$PR_INFO" | grep -q "error\|Error\|ERROR" 2>/dev/null; then
    log_error "Failed to fetch PR #${PR_NUMBER}."
    echo "Error details: $PR_INFO"
    echo ""
    echo "Please check:"
    echo "  - You're in a Git repository directory"
    echo "  - The repository has a GitHub remote"
    echo "  - You have permission to view the PR"
    echo "  - GitHub CLI is properly configured (run 'gh auth status')"
    exit 1
fi

# Parse repository information
OWNER=$(echo "$PR_INFO" | jq -r '.headRepositoryOwner.login' 2>/dev/null)
REPO=$(echo "$PR_INFO" | jq -r '.headRepository.name' 2>/dev/null)
BASE_BRANCH=$(echo "$PR_INFO" | jq -r '.baseRefName' 2>/dev/null)
HEAD_BRANCH=$(echo "$PR_INFO" | jq -r '.headRefName' 2>/dev/null)
HEAD_SHA=$(echo "$PR_INFO" | jq -r '.headRefOid' 2>/dev/null)

if [ -z "$OWNER" ] || [ -z "$REPO" ] || [ -z "$BASE_BRANCH" ] || [ -z "$HEAD_BRANCH" ] || [ -z "$HEAD_SHA" ] || \
   [ "$OWNER" = "null" ] || [ "$REPO" = "null" ] || [ "$BASE_BRANCH" = "null" ] || [ "$HEAD_BRANCH" = "null" ] || [ "$HEAD_SHA" = "null" ]; then
    log_error "Could not parse repository details from PR response."
    echo "This might indicate:"
    echo "  - Invalid PR number"
    echo "  - Insufficient permissions"
    echo "  - Repository access issues"
    echo ""
    echo "Debug info: $PR_INFO"
    exit 1
fi

log_info "Repository: $OWNER/$REPO, Base Branch: $BASE_BRANCH, Head Branch: $HEAD_BRANCH"

# --- 3. Fetch All Context Components ---

# Fetch Metadata (Title and Body)
log_info "Fetching title and body..."
METADATA=$(gh pr view "$PR_NUMBER" --json title,body --jq '"PR Title: \(.title)\n\nPR Body:\n\(.body)"' 2>/dev/null)
if [ -z "$METADATA" ]; then
    log_error "Failed to fetch PR metadata. Continuing with available data..."
    METADATA="PR Title: [Error fetching title]\n\nPR Body:\n[Error fetching body]"
fi

# Fetch Timeline Comments
log_info "Fetching timeline comments (all pages)..."
TIMELINE_COMMENTS=$(gh api --paginate "/repos/${OWNER}/${REPO}/issues/${PR_NUMBER}/comments" 2>/dev/null | \
  jq -r '.[] | select(.body and .body != "" and (.user.type != "Bot")) | "- Timeline comment from @\(.user.login):\n  \(.body)\n---"' 2>/dev/null | \
  tr -d '\r')

# Fetch Code Review (Diff) Comments
log_info "Fetching code review comments (all pages)..."
DIFF_COMMENTS=$(gh api --paginate "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/comments" 2>/dev/null | \
  jq -r '.[] | select(.body and .body != "" and (.user.type != "Bot")) | "- Code comment from @\(.user.login) on `\(.path)` (line \(.line)):\n  \(.body)\n---"' 2>/dev/null | \
  tr -d '\r')

# Fetch Review Summary Comments
log_info "Fetching review summaries (all pages)..."
REVIEWS=$(gh api --paginate "/repos/${OWNER}/${REPO}/pulls/${PR_NUMBER}/reviews" 2>/dev/null | \
  jq -r '.[] | select(.body and .body != "" and (.user.type != "Bot")) | "- Review summary from @\(.user.login) (\(.state)):\n  \(.body)\n---"' 2>/dev/null | \
  tr -d '\r')

# Generate Diff Content
log_info "Generating diff from base branch '${BASE_BRANCH}' to PR head '${HEAD_SHA}'..."
# Fetch the PR's head ref to ensure we have the exact commits
if ! git fetch origin "${HEAD_BRANCH}" &> /dev/null; then
    log_error "Failed to fetch PR head branch '${HEAD_BRANCH}'. Continuing with current state..."
fi
# Ensure the local git remote is up to date with the base branch
if ! git fetch origin "${BASE_BRANCH}" &> /dev/null; then
    log_error "Failed to fetch base branch '${BASE_BRANCH}'. Continuing with current state..."
fi
# Use the exact commit SHA from the PR to generate diff
DIFF_CONTENT=$(git diff "origin/${BASE_BRANCH}...${HEAD_SHA}" 2>/dev/null)
if [ -z "$DIFF_CONTENT" ]; then
    DIFF_CONTENT="[No differences found or error generating diff]"
fi

# --- 4. Format Output Functions ---

format_text_output() {
    # Start with a clean file
    > "$OUTPUT_FILE"

    # Using a single printf statement for structured and safe writing
    printf "%s\n" \
    "################################################################################" \
    "# PULL REQUEST CONTEXT: #${PR_NUMBER}" \
    "################################################################################" \
    "" \
    "--- METADATA ---" \
    "${METADATA}" \
    "" \
    "--- ALL COMMENTS ---" > "$OUTPUT_FILE"

    # Append comments only if they exist to keep the file clean
    if [ -n "$TIMELINE_COMMENTS" ]; then
        printf "\n## Timeline Comments ##\n%s\n" "$TIMELINE_COMMENTS" >> "$OUTPUT_FILE"
    fi
    if [ -n "$DIFF_COMMENTS" ]; then
        printf "\n## Code Review Comments ##\n%s\n" "$DIFF_COMMENTS" >> "$OUTPUT_FILE"
    fi
    if [ -n "$REVIEWS" ]; then
        printf "\n## Review Summaries ##\n%s\n" "$REVIEWS" >> "$OUTPUT_FILE"
    fi

    # Append the Diff
    printf "\n%s\n" \
    "--- GIT DIFF ---" \
    "${DIFF_CONTENT}" >> "$OUTPUT_FILE"
}

format_markdown_output() {
    # Start with a clean file
    > "$OUTPUT_FILE"

    # Markdown formatted output
    printf "%s\n" \
    "# Pull Request Context: #${PR_NUMBER}" \
    "" \
    "## 📋 Metadata" \
    "" \
    "${METADATA}" \
    "" \
    "## 💬 All Comments" \
    "" > "$OUTPUT_FILE"

    # Append comments with markdown formatting
    if [ -n "$TIMELINE_COMMENTS" ]; then
        printf "\n### Timeline Comments\n\n%s\n" "$TIMELINE_COMMENTS" >> "$OUTPUT_FILE"
    fi
    if [ -n "$DIFF_COMMENTS" ]; then
        printf "\n### Code Review Comments\n\n%s\n" "$DIFF_COMMENTS" >> "$OUTPUT_FILE"
    fi
    if [ -n "$REVIEWS" ]; then
        printf "\n### Review Summaries\n\n%s\n" "$REVIEWS" >> "$OUTPUT_FILE"
    fi

    # Append the Diff with proper code block
    printf "\n## 🔍 Git Diff\n\n\`\`\`diff\n%s\n\`\`\`\n" "${DIFF_CONTENT}" >> "$OUTPUT_FILE"
}

# --- 5. Assemble the Output File ---

log_info "Assembling all context into ${OUTPUT_FILE}..."

# Check if we can write to the output file
if ! touch "$OUTPUT_FILE" 2>/dev/null; then
    log_error "Cannot write to output file '${OUTPUT_FILE}'. Please check permissions."
    exit 1
fi

if [ "$OUTPUT_FORMAT" = "markdown" ]; then
    format_markdown_output
else
    format_text_output
fi

# Verify the output file was created successfully
if [ ! -f "$OUTPUT_FILE" ] || [ ! -s "$OUTPUT_FILE" ]; then
    log_error "Failed to create output file '${OUTPUT_FILE}' or file is empty."
    exit 1
fi

log_success "Success! All context has been saved to '${OUTPUT_FILE}'."

if [ "$OUTPUT_FORMAT" = "markdown" ]; then
    echo "📝 Markdown format ready for viewing in any markdown reader."
else
    echo "📄 Text format ready for LLM input."
fi