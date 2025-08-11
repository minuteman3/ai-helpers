#!/bin/bash

set -e

echo "🤖 AI Helpers Installation Script"
echo "=================================="

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- AI Model Checks ---
echo "🔎 Checking for AI models..."

# Check for Claude CLI
if ! command -v claude &> /dev/null; then
    echo "🟡 Claude CLI not found. To use Claude, please install it:"
    echo "   Visit: https://claude.ai/code"
else
    echo "✅ Claude CLI found"
fi

# Check for Gemini CLI
if ! command -v gemini &> /dev/null; then
    echo "🟡 Gemini CLI not found. To use Gemini, please install it:"
    echo "   Run: npm install -g @google/gemini-cli"
else
    echo "✅ Gemini CLI found"
fi

# --- Dependency Checks ---
echo "
🔎 Checking for other dependencies."

# Check if GitHub CLI is available (optional for ai-pr)
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found"
else
    echo "⚠️  GitHub CLI not found. Install it to use ai-pr:"
    echo "   Visit: https://cli.github.com/"
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.6+ for the ai-commit command"
    exit 1
fi

echo "✅ Python 3 found"

# --- Script Setup ---
echo "
🔧 Setting up scripts."

# Make scripts executable
echo "📝 Making scripts executable..."
chmod +x "$SCRIPT_DIR/ai-pr" "$SCRIPT_DIR/ai-commit"

# Set up bin directory with symlinks
echo "🔧 Setting up bin directory with symlinks..."
mkdir -p "$SCRIPT_DIR/bin"
cd "$SCRIPT_DIR/bin"
ln -sf ../ai-pr ai-pr
ln -sf ../ai-pr git-auto-pr
ln -sf ../ai-commit ai-commit
chmod +x ai-pr git-auto-pr ai-commit

# Note: Git hooks setup has been removed as ai-commit is now a standalone command

# --- PATH Configuration ---
echo "
📋 Configuring PATH."

# Add tools to PATH (check if already in PATH)
NEEDS_PATH_UPDATE=false
BIN_DIR="$SCRIPT_DIR/bin"

if ! command -v ai-pr &> /dev/null || ! command -v ai-commit &> /dev/null; then
    NEEDS_PATH_UPDATE=true
fi

if [[ "$NEEDS_PATH_UPDATE" == "true" ]]; then
    echo "➕ Adding AI helpers to PATH..."
    
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

# --- Final Instructions ---
echo ""
echo "🎉 Installation Complete!" 
echo ""
echo "What was installed:"
echo "  • ai-commit: Command to generate AI-powered commit messages."
echo "  • ai-pr / git-auto-pr: Command to create PRs with AI-generated descriptions."
echo ""
echo "How to use:"
echo "  • Stage your changes with 'git add' then run 'ai-commit' to generate a commit message."
echo "  • Use 'ai-pr' or 'git auto-pr' to create pull requests."
echo ""
echo "Configuration:"
echo "  • By default, the scripts use Claude."
echo "  • To use Gemini, set the AI_HELPER_COMMAND environment variable:"
echo "    export AI_HELPER_COMMAND=gemini"
echo "  • To use specific models within any provider:"
echo "    export AI_HELPER_MODEL=claude-3-5-sonnet-20241022    # For Claude"
echo "    export AI_HELPER_MODEL=gemini-1.5-pro                # For Gemini"
echo "    (This will be passed as --model parameter to the CLI tools)"
echo ""
echo "Test the installation:"
echo "  1. Navigate to any Git repository."
echo "  2. Make some changes and stage them with 'git add'."
echo "  3. Run 'ai-commit' to generate and create a commit with AI assistance."
echo "  4. Try 'git auto-pr' to create a pull request."
echo ""
