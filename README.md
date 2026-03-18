# pr-dump

> Dump all GitHub PR context (metadata, comments, diffs) into a single text file for LLM review.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**📖 [中文文档](README_CN.md)**

## Quick Start

```bash
# Install
brew tap CheerChen/tap
brew install pr-dump

# Option 1: Use URL (works anywhere)
pr-dump https://github.com/owner/repo/pull/568

# Option 2: Use PR number (inside repository directory)
cd your-repository
pr-dump 568
```

## Features

- **Complete Context**: Fetches PR metadata, all comments, and git diff
- **LLM-Ready**: Outputs structured markdown perfect for AI code review
- **Bot-Free**: Automatically filters out bot comments
- **HTML Noise Cleaning**: Strips bot-generated HTML tables, `&nbsp;`, and hash links from PR body; reformats File Walkthrough into compact plain text (on by default)
- **Grouped Review Comments**: Code review comments grouped by file, preserving conversation order
- **Fast**: Single command to gather everything you need
- **Flexible Diff Modes**: Full, compact (paths + line numbers), or stat-only output

## Installation

### Option 1: Homebrew (Recommended)

```bash
brew tap CheerChen/tap
brew install pr-dump
```

### Option 3: Install to PATH

```bash
git clone https://github.com/CheerChen/pr-dump.git
cd pr-dump
./install.sh

# Or uninstall
./install.sh --uninstall
```

## Usage

### Two Input Modes

**1. URL Mode (works anywhere)**

```bash
pr-dump https://github.com/owner/repo/pull/123
pr-dump -f markdown https://github.com/owner/repo/pull/568
```

**2. Number Mode (requires git repository)**

```bash
cd /path/to/your/repository
pr-dump 123
```

### Basic Usage

```bash
# URL mode - works from any directory
pr-dump https://github.com/CheerChen/pr-dump/pull/1

# Number mode - must be in repository directory
cd my-awesome-project
pr-dump 123

# Advanced options
pr-dump --output custom.md https://github.com/owner/repo/pull/456
pr-dump --diff-mode compact 123  # Paths + line numbers only
pr-dump --diff-mode stat 123     # Statistics only
pr-dump --no-clean-body 123      # Disable HTML noise cleaning
pr-dump --verbose https://github.com/owner/repo/pull/789
```

**Examples:**

```bash
# URL mode - analyze any public PR without cloning
pr-dump https://github.com/facebook/react/pull/12345

# Number mode in your repository
cd my-project
pr-dump 123                              # Output: pr-123.md
pr-dump -o review.md 789                 # Output: review.md

# Compact diff mode - ideal when LLM is already in project directory
# Outputs only file paths and line numbers, reducing token consumption
pr-dump -d compact 789
```

**Output**: Creates `pr-<number>.txt` (or `pr-<number>.md` for markdown format, or custom filename) with complete PR context.

## Example Output

```markdown
# Pull Request Context: #42

## 📋 Metadata
PR Title: Add user authentication system
PR Body: This PR implements JWT-based authentication...

[File Changes]
auth.go: Implement JWT middleware (+45/-0)
router.go: Register auth routes (+12/-2)

## 💬 All Comments

### Timeline Comments

- @developer1: Looks good, but consider adding rate limiting...

### Code Review Comments

#### `auth.go`

- @reviewer (L25): This function should handle edge cases...
- @author (L25): Good point, added nil check in latest commit.

## 🔍 Git Diff

```diff
diff --git a/auth.go b/auth.go
+package auth
...
```
```

## Use Cases

- **AI Code Review**: Feed complete PR context to Gemini, GPT, or Claude
- **Non-native Communication**: Get help replying to team members' review comments
- **Complex PR Analysis**: Quickly understand long discussions and changes
- **Documentation**: Generate release notes and technical summaries

### Dependencies (automatically handled by brew installation)

- [GitHub CLI](https://cli.github.com/) (`gh`) - authenticated with your account
- [jq](https://jqlang.github.io/jq/) - command-line JSON processor

## License

MIT © [CheerChen](https://github.com/CheerChen)
