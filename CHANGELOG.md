# Changelog

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