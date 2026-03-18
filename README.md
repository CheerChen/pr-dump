# pr-dump

> Dump all GitHub PR context (metadata, comments, diffs) into a single text file for LLM review.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**📖 [中文文档](README_CN.md)**

## Quick Start

```bash
# Install
brew tap CheerChen/pr-dump
brew install pr-dump

# Dump PR context from repository directory
cd your-repository
pr-dump 568
```

## Features

- **Complete Context**: Fetches PR metadata, all comments, and git diff
- **LLM-Ready**: Outputs structured text perfect for AI code review
- **Bot-Free**: Automatically filters out bot comments
- **Fast**: Single command to gather everything you need
- **Flexible Diff Modes**: Full, compact (paths + line numbers), or stat-only output

## Installation

### Option 1: Homebrew (Recommended)
```bash
brew tap CheerChen/pr-dump
brew install pr-dump
```

### Option 2: Direct Download
```bash
curl -O https://raw.githubusercontent.com/CheerChen/pr-dump/master/pr-dump.sh
chmod +x pr-dump.sh
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

**⚠️ Important: Run from inside the target repository directory**

```bash
# Navigate to your repository first
cd /path/to/your/repository

# Basic usage (if installed via brew/install.sh)
pr-dump <PR_NUMBER>

# Or if using downloaded script
./pr-dump.sh <PR_NUMBER>

# Advanced options
pr-dump --output pr123.md --format markdown 123
pr-dump --diff-mode compact 123  # Paths + line numbers only
pr-dump --diff-mode stat 123     # Statistics only
pr-dump --verbose 42
pr-dump --help
```

**Examples:**
```bash
# Dump context for PR #123
cd my-awesome-project
pr-dump 123

# Custom output file and markdown format
pr-dump -o review.md -f markdown 456

# Compact diff mode - ideal when LLM is already in project directory
# Outputs only file paths and line numbers, reducing token consumption
pr-dump -d compact 789
```

**Output**: Creates `review.txt` (or custom filename) with complete PR context.

## Example Output

```
################################################################################
# PULL REQUEST CONTEXT: #42
################################################################################

--- METADATA ---
PR Title: Add user authentication system
PR Body: This PR implements JWT-based authentication...

--- ALL COMMENTS ---
## Timeline Comments ##
- Timeline comment from @developer1:
  Looks good, but consider adding rate limiting...

## Code Review Comments ##
- Code comment from @reviewer on `auth.go` (line 25):
  This function should handle edge cases...

--- GIT DIFF ---
diff --git a/auth.go b/auth.go
new file mode 100644
index 0000000..abc1234
+++ b/auth.go
@@ -0,0 +1,45 @@
+package auth
...
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