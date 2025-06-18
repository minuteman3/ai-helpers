# AI Helpers

A collection of AI-powered Git tools that use Claude Code to generate intelligent commit messages and pull request descriptions.

## Tools

### `ai-commit`
Generates intelligent commit messages based on your staged changes using Claude Code.

**Features:**
- Analyzes staged git changes and generates contextual commit messages
- Considers branch context and recent commit history
- Provides fallback prompt if Claude Code is unavailable
- Interactive confirmation before committing

**Usage:**
```bash
# Stage your changes first
git add .

# Generate and create commit
ai-commit
```

### `ai-pr`
Creates pull requests with AI-generated titles and descriptions using Claude Code.

**Features:**
- Analyzes branch commits and changes compared to main/master
- Generates professional PR titles and descriptions
- Creates draft PRs using GitHub CLI
- Interactive confirmation before creation

**Usage:**
```bash
# Push your branch first
git push -u origin your-branch

# Generate and create PR
ai-pr
```

## Setup

1. Ensure you have [Claude Code](https://claude.ai/code) installed
2. For PR creation, install [GitHub CLI](https://cli.github.com/)
3. Make the scripts executable and add to your PATH:

```bash
# Make executable
chmod +x ai-commit ai-pr

# Add to PATH (choose one method):

# Option 1: Copy to a directory already in PATH
cp ai-commit ai-pr /usr/local/bin/

# Option 2: Add this directory to PATH in your shell config
echo 'export PATH="/path/to/ai-helpers:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Requirements

- Git repository
- Claude Code CLI
- GitHub CLI (for `ai-pr`)
- Zsh shell