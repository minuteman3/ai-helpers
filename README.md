# AI Helpers

A collection of AI-powered Git tools that enhance your development workflow with intelligent commit messages, pull request descriptions, and automatic commit message improvement.

## Tools

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

# Generate and create PR (either command works)
ai-pr
git auto-pr
```

### `prepare-commit-msg`
A Git hook that automatically enhances commit messages using Claude Code. This hook analyzes your staged changes, branch context, and recent commits to suggest improved commit messages.

**Features:**
- Automatically triggered on every commit
- Analyzes staged changes and full branch context
- Considers recent commit history for consistency
- Provides interactive options to use, edit, or keep original message
- Shows detailed analysis of changes for better understanding
- Handles merge, squash, and rebase commits appropriately

**Usage:**
The hook runs automatically when you commit. After staging your changes:

```bash
git commit
```

You'll be presented with Claude's analysis and suggested commit message, with options to:
1. Use the AI-generated message
2. Edit the message before committing
3. Keep your original message
4. Cancel the commit

## Installation

### Quick Install
Run the install script to set up the `prepare-commit-msg` hook globally:

```bash
./install.sh
```

This will:
- Make all scripts executable
- Install the `prepare-commit-msg` hook globally for all your repositories
- Configure Git to use the global hooks directory
- Set up `git auto-pr` as a custom Git command
- Add the tools to your PATH

### Manual Setup

1. **Prerequisites:**
   - [Claude Code](https://claude.ai/code) CLI installed
   - [GitHub CLI](https://cli.github.com/) for PR creation
   - Python 3.6+ (for the prepare-commit-msg hook)

2. **Make scripts executable:**
   ```bash
   chmod +x ai-pr prepare-commit-msg
   ```

3. **Set up Git custom command and add to PATH:**
   ```bash
   # Create bin directory and symlinks
   mkdir -p bin
   cd bin
   ln -sf ../ai-pr ai-pr
   ln -sf ../ai-pr git-auto-pr
   chmod +x ai-pr git-auto-pr
   cd ..
   
   # Add to PATH (choose one method):
   # Option 1: Copy to a directory already in PATH
   cp bin/ai-pr /usr/local/bin/
   cp bin/git-auto-pr /usr/local/bin/
   
   # Option 2: Add bin directory to PATH in your shell config
   echo 'export PATH="/path/to/ai-helpers/bin:$PATH"' >> ~/.zshrc
   source ~/.zshrc
   ```

4. **Install prepare-commit-msg hook globally:**
   ```bash
   # Create global hooks directory if it doesn't exist
   mkdir -p ~/.git-hooks
   
   # Copy the hook
   cp prepare-commit-msg ~/.git-hooks/
   
   # Configure Git to use the global hooks directory
   git config --global core.hooksPath ~/.git-hooks
   ```

## Requirements

- Git repository
- Claude Code CLI
- GitHub CLI (for `ai-pr`)
- Python 3.6+ (for `prepare-commit-msg`)