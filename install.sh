#!/bin/bash

set -e

echo "🤖 AI Helpers Installation Script"
echo "=================================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if Claude Code CLI is available
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code CLI not found. Please install it first:"
    echo "   Visit: https://claude.ai/code"
    exit 1
fi

echo "✅ Claude Code CLI found"

# Check if GitHub CLI is available (optional for ai-pr)
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found"
else
    echo "⚠️  GitHub CLI not found. Install it to use ai-pr:"
    echo "   Visit: https://cli.github.com/"
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.6+ for the prepare-commit-msg hook"
    exit 1
fi

echo "✅ Python 3 found"

# Make scripts executable
echo "📝 Making scripts executable..."
chmod +x "$SCRIPT_DIR/ai-pr" "$SCRIPT_DIR/prepare-commit-msg"

# Set up bin directory with git commands
echo "🔧 Setting up Git custom commands..."
mkdir -p "$SCRIPT_DIR/bin"
cd "$SCRIPT_DIR/bin"
ln -sf ../ai-pr ai-pr
ln -sf ../ai-pr git-auto-pr
chmod +x ai-pr git-auto-pr

# Determine the global hooks directory
GLOBAL_HOOKS_DIR=""

# Check if user already has a global hooks directory configured
EXISTING_HOOKS_PATH=$(git config --global --get core.hooksPath 2>/dev/null || echo "")

if [[ -n "$EXISTING_HOOKS_PATH" ]]; then
    # Expand tilde if present
    if [[ "$EXISTING_HOOKS_PATH" == "~"* ]]; then
        GLOBAL_HOOKS_DIR="${HOME}${EXISTING_HOOKS_PATH:1}"
    else
        GLOBAL_HOOKS_DIR="$EXISTING_HOOKS_PATH"
    fi
    echo "📁 Using existing global hooks directory: $GLOBAL_HOOKS_DIR"
else
    # Set up a new global hooks directory
    GLOBAL_HOOKS_DIR="$HOME/.git-hooks"
    echo "📁 Creating new global hooks directory: $GLOBAL_HOOKS_DIR"
    git config --global core.hooksPath "$GLOBAL_HOOKS_DIR"
fi

# Create the global hooks directory if it doesn't exist
mkdir -p "$GLOBAL_HOOKS_DIR"

# Install the prepare-commit-msg hook
echo "🔗 Installing prepare-commit-msg hook globally..."
cp "$SCRIPT_DIR/prepare-commit-msg" "$GLOBAL_HOOKS_DIR/"
chmod +x "$GLOBAL_HOOKS_DIR/prepare-commit-msg"

# Add tools to PATH (check if already in PATH)
NEEDS_PATH_UPDATE=false
BIN_DIR="$SCRIPT_DIR/bin"

if ! command -v ai-pr &> /dev/null || ! command -v git-auto-pr &> /dev/null; then
    NEEDS_PATH_UPDATE=true
fi

if [[ "$NEEDS_PATH_UPDATE" == "true" ]]; then
    echo "📋 Adding AI helpers to PATH..."
    
    # Determine shell config file
    SHELL_CONFIG=""
    if [[ "$SHELL" == *"zsh"* ]] || [[ -n "$ZSH_VERSION" ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]] || [[ -n "$BASH_VERSION" ]]; then
        if [[ -f "$HOME/.bash_profile" ]]; then
            SHELL_CONFIG="$HOME/.bash_profile"
        else
            SHELL_CONFIG="$HOME/.bashrc"
        fi
    else
        echo "⚠️  Could not determine shell config file. Please manually add to PATH:"
        echo "   export PATH=\"$BIN_DIR:\$PATH\""
        SHELL_CONFIG=""
    fi
    
    if [[ -n "$SHELL_CONFIG" ]]; then
        # Check if the bin directory is already in the config file
        PATH_EXPORT="export PATH=\"$BIN_DIR:\$PATH\""
        if ! grep -q "$BIN_DIR" "$SHELL_CONFIG" 2>/dev/null; then
            echo "$PATH_EXPORT" >> "$SHELL_CONFIG"
            echo "✅ Added to $SHELL_CONFIG"
            echo "📝 Please run: source $SHELL_CONFIG"
        else
            echo "✅ PATH already configured in $SHELL_CONFIG"
        fi
    fi
else
    echo "✅ AI helpers already available in PATH"
fi

echo ""
echo "🎉 Installation Complete!"
echo ""
echo "What's installed:"
echo "  • prepare-commit-msg: Globally installed Git hook"
echo "  • ai-pr: Available in PATH for creating PRs"
echo "  • git auto-pr: Custom Git command for creating PRs"
echo ""
echo "Usage:"
echo "  • The prepare-commit-msg hook will automatically run on every commit"
echo "  • Use 'ai-pr' or 'git auto-pr' to create pull requests with AI-generated descriptions"
echo ""
echo "Test the installation:"
echo "  1. Navigate to any Git repository"
echo "  2. Make some changes and run 'git commit'"
echo "  3. You should see Claude's commit message suggestions"
echo "  4. Try 'git auto-pr' to create a pull request"
echo ""