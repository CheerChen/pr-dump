# Changelog

## [0.4.0] - 2026-02-24

### Added
- `--clean-body` flag (default: **on**): cleans bot-generated HTML noise from PR body
  - Reformats "File Walkthrough" HTML tables (injected by PR bots such as CodiumAI/pr-agent) into compact plain text: `filename: description (+N/-M)`
  - Strips `&nbsp;`, HTML tags, and long GitHub diff hash links
  - Use `--no-clean-body` to opt out
- Code review comments now grouped by file under `####` headings, preserving conversation order within each file
- Multi-line comment bodies indented with 2 spaces so code blocks and suggestions stay inside their list item
- `(line null)` no longer appears for file-level review comments (line number omitted when unavailable)

### Changed
- Default output format changed from `text` to `markdown` (default output file is now `pr-<number>.md`)
- Timeline comments and review summaries reformatted: removed `---` separators and redundant `Timeline comment from` / `Review summary from` prefixes; entries separated by blank lines

### Token Impact
- Typical savings: **~20–25%** fewer tokens vs v0.3.0 on PRs with bot-generated File Walkthrough tables

## [0.3.0] - 2026-01-20

### Added
- Support for full GitHub PR URL as input (works anywhere without git repository)
- Two input modes:
  - **URL mode**: `pr-dump https://github.com/owner/repo/pull/123` (works anywhere)
  - **Number mode**: `pr-dump 123` (requires git repository)
- Smart default output filename: `pr-<number>.txt` or `pr-<number>.md` based on format
- Enhanced error messages with clear troubleshooting guidance

### Changed
- Default output filename changed from `review.txt` to `pr-<number>.txt`
- URL mode no longer requires being inside a git repository
- Improved repository detection and validation
- Better error handling with specific error messages

### Improved
- More flexible usage: can now analyze PRs from any repository without cloning
- Clearer help documentation with separate argument and option sections
- Better UX with context-aware error messages

## [0.2.0] - 2025-12-17

### Added
- New `--diff-mode` / `-d` option with three modes:
  - `full` (default): Complete diff with all code changes
  - `compact`: Only file paths, line numbers, and function context (ideal for LLM when already in project directory)
  - `stat`: Only file change statistics
- Compact mode reduces token consumption by showing only file paths and line ranges

### Features
- `-d, --diff-mode MODE`: Select diff output mode

## [0.1.1] - 2025-11-14

### Fixed
- Fixed issue where git diff could include unrelated changes from current branch
- Now uses PR's exact commit SHA to generate accurate diff
- Added fetching of PR head branch to ensure correct commit references

## [0.1.0] - 2025-09-16

### Added
- Complete PR context extraction (metadata, comments, diff)
- Multiple output formats (text, markdown)
- CLI interface with full argument support
- Bot comment filtering
- Installation script

### Features
- `--output` / `-o`: Custom output file name
- `--format` / `-f`: Output format (text/markdown)
- `--verbose` / `-v`: Detailed progress
- `--help` / `-h`: Help documentation
- `--version`: Version information