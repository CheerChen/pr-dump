# pr-dump

> 将 GitHub PR 的所有上下文（元数据、评论、代码变更）导出到单个文本文件中，便于 AI 代码审查。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**📖 [English Documentation](README.md)**

## 快速开始

```bash
# 安装
brew tap CheerChen/pr-dump
brew install pr-dump

# 在仓库目录内导出PR上下文
cd your-repository
pr-dump 568
```

## 功能特性

- **完整上下文**：获取 PR 元数据、所有评论和 git 差异
- **AI Ready**：输出适合 AI 代码审查的结构化文本
- **无 Bot 干扰**：自动过滤 Bot(`pr-agent`) 评论
- **快速**：一条命令获取所有需要的信息
- **灵活的 Diff 模式**：支持完整输出、精简（路径+行号）或仅统计信息

## 安装方法

### 方式一：Homebrew（推荐）

```bash
brew tap CheerChen/pr-dump
brew install pr-dump
```

### 方式二：直接下载

```bash
curl -O https://raw.githubusercontent.com/CheerChen/pr-dump/master/pr-dump.sh
chmod +x pr-dump.sh
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

**⚠️ 重要：必须在目标仓库目录内执行**

```bash
# 首先进入你的仓库目录
cd /path/to/your/repository

# 基本用法
pr-dump <PR编号>

# 或者使用下载的脚本
./pr-dump.sh <PR编号>

# 高级选项
pr-dump --output pr568.md --format markdown 568
pr-dump --diff-mode compact 568  # 仅输出文件路径和行号
pr-dump --diff-mode stat 568     # 仅输出统计信息
pr-dump --help
```

### Diff 输出模式

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| `full` (默认) | 完整的 diff 输出 | LLM 需要查看所有代码变更 |
| `compact` | 仅文件路径、行号和函数上下文 | LLM 已在目标工程目录，可自行读取文件 |
| `stat` | 仅文件变更统计 | 快速了解 PR 规模 |

## 输出示例

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
