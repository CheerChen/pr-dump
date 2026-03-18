# pr-dump

> 将 GitHub PR 的所有上下文（元数据、评论、代码变更）导出到单个文本文件中，便于 AI 代码审查。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**📖 [English Documentation](README.md)**

## 快速开始

```bash
# 安装
brew tap CheerChen/tap
brew install pr-dump

# 方式一：使用 URL（任何目录下都可用）
pr-dump https://github.com/owner/repo/pull/568

# 方式二：使用 PR 编号（需要在仓库目录内）
cd your-repository
pr-dump 568
```

## 功能特性

- **完整上下文**：获取 PR 元数据、所有评论和 git 差异
- **AI Ready**：输出适合 AI 代码审查的结构化 Markdown
- **无 Bot 干扰**：自动过滤 Bot(`pr-agent`) 评论
- **HTML 噪音清理**：自动剥离 PR body 中 Bot 注入的 HTML 表格、`&nbsp;` 和 hash 链接；将 File Walkthrough 重格式化为紧凑纯文本（默认开启）
- **评论按文件分组**：Code Review 评论按文件归组，保留对话顺序
- **快速**：一条命令获取所有需要的信息
- **灵活的 Diff 模式**：支持完整输出、精简（路径+行号）或仅统计信息

## 安装方法

### 方式一：Homebrew（推荐）

```bash
brew tap CheerChen/tap
brew install pr-dump
```

### 方式三：安装到系统 PATH

```bash
git clone https://github.com/CheerChen/pr-dump.git
cd pr-dump
./install.sh

# 卸载
./install.sh --uninstall
```

## 使用方法

### 两种输入模式

**1. URL 模式（任何目录下都可用）**

```bash
pr-dump https://github.com/owner/repo/pull/123
pr-dump -f markdown https://github.com/owner/repo/pull/568
```

**2. PR 编号模式（需要在 git 仓库内）**

```bash
cd /path/to/your/repository
pr-dump 123
```

### 基本用法

```bash
# URL 模式 - 可在任何目录执行
pr-dump https://github.com/CheerChen/pr-dump/pull/1

# PR 编号模式 - 必须在仓库目录内
cd my-awesome-project
pr-dump 123

# 高级选项
pr-dump --output custom.md https://github.com/owner/repo/pull/456
pr-dump --diff-mode compact 123  # 仅输出文件路径和行号
pr-dump --diff-mode stat 123     # 仅输出统计信息
pr-dump --no-clean-body 123      # 禁用 HTML 噪音清理
pr-dump --verbose https://github.com/owner/repo/pull/789
```

**使用示例：**

```bash
# URL 模式 - 无需克隆即可分析任何公开 PR
pr-dump https://github.com/facebook/react/pull/12345

# 在你的仓库中使用 PR 编号
cd my-project
pr-dump 123                              # 输出: pr-123.md
pr-dump -o review.md 789                 # 输出: review.md

# 精简 diff 模式 - 适合 LLM 已在项目目录的情况
# 仅输出文件路径和行号，减少 token 消耗
pr-dump -d compact 789
```

**输出**：生成 `pr-<编号>.txt`（markdown 格式为 `pr-<编号>.md`，或自定义文件名）,包含完整 PR 上下文。

### Diff 输出模式

| 模式            | 说明                         | 适用场景                             |
| --------------- | ---------------------------- | ------------------------------------ |
| `full` (默认) | 完整的 diff 输出             | LLM 需要查看所有代码变更             |
| `compact`     | 仅文件路径、行号和函数上下文 | LLM 已在目标工程目录，可自行读取文件 |
| `stat`        | 仅文件变更统计               | 快速了解 PR 规模                     |

## 输出示例

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

## 使用场景

- **AI 代码审查**：为 Gemini、GPT 或 Claude 提供完整的 PR 上下文
- **非母语沟通**：获得 Team 成员审查评论的回复帮助
- **复杂 PR 分析**：快速理解长时间讨论和变更
- **文档生成**：生成发布说明和技术总结

### 依赖工具（brew 安装会自动处理）

- [GitHub CLI](https://cli.github.com/) (`gh`) - 需要登录认证
- [jq](https://jqlang.github.io/jq/) - 命令行 JSON 处理器

## 许可证

MIT © [CheerChen](https://github.com/CheerChen)
