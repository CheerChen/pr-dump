# Changelog

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