#!/bin/bash
#
# worktree-slots installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/xpload32004/worktree-slots/main/install.sh | bash
#
# Or clone and run locally:
#   git clone https://github.com/xpload32004/worktree-slots.git
#   cd worktree-slots && ./install.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${CYAN}$1${NC}"; }
success() { echo -e "${GREEN}$1${NC}"; }
warn() { echo -e "${YELLOW}$1${NC}"; }
error() { echo -e "${RED}Error:${NC} $1" >&2; exit 1; }

# Configuration
INSTALL_DIR="${INSTALL_DIR:-$HOME/.local/bin}"
REPO_URL="https://raw.githubusercontent.com/xpload32004/worktree-slots/main"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG_DIR="$XDG_CONFIG_HOME/worktree-slots"

echo -e "${BOLD}worktree-slots installer${NC}"
echo ""

# Create install directory if needed
if [[ ! -d "$INSTALL_DIR" ]]; then
    info "Creating $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    warn "Note: $INSTALL_DIR is not in your PATH"
    echo "Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo -e "  ${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${NC}"
    echo ""
fi

# Download or copy the script
if [[ -f "worktree-slots" ]]; then
    # Running from cloned repo
    info "Installing from local copy..."
    cp worktree-slots "$INSTALL_DIR/worktree-slots"
else
    # Download from GitHub
    info "Downloading worktree-slots..."
    curl -fsSL "$REPO_URL/worktree-slots" -o "$INSTALL_DIR/worktree-slots"
fi

chmod +x "$INSTALL_DIR/worktree-slots"

success "Installed worktree-slots to $INSTALL_DIR/worktree-slots"

# Create example config if none exists
if [[ ! -f "$CONFIG_DIR/config" ]]; then
    echo ""
    info "Creating example config at $CONFIG_DIR/config..."
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_DIR/config" << 'EOF'
# worktree-slots configuration
# See: worktree-slots help

# Where your git repos live
REPOS_DIR="$HOME/repos"

# Number of worktree slots (1-N)
NUM_SLOTS=5

# Open command configuration (for 'worktree-slots open <slot>')
# Choose one of the following options:

# Option 1: Simple - just specify an editor
# OPEN_EDITOR="code"      # VS Code
# OPEN_EDITOR="nvim"      # Neovim
# OPEN_EDITOR="vim"       # Vim

# Option 2: Terminal + editor (macOS)
# OPEN_TERMINAL="iTerm"   # or "Ghostty", "Terminal"
# OPEN_EDITOR="nvim"

# Option 3: Full custom command
# Variables available: $slot_dir, $branch, $project, $slot
# OPEN_COMMAND='cd $slot_dir && code .'
EOF
    success "Created example config"
    echo "Edit $CONFIG_DIR/config to customize your setup."
else
    info "Config already exists at $CONFIG_DIR/config"
fi

echo ""
success "Installation complete!"
echo ""
echo "Quick start:"
echo -e "  ${CYAN}cd ~/repos/myproject${NC}       # Go to a git repo"
echo -e "  ${CYAN}worktree-slots status${NC}      # See slot status"
echo -e "  ${CYAN}worktree-slots use 1 my-feature${NC}  # Create a slot"
echo ""
echo "Run ${CYAN}worktree-slots help${NC} for more info."
