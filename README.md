# worktree-slots

Manage git worktree slots for parallel development. Work on multiple branches simultaneously without stashing or switching—each slot is an independent worktree.

## Why?

When working on multiple features or reviewing MRs, constantly switching branches is painful:
- Stash changes, switch, unstash, repeat
- IDE reindexes everything on each switch
- Build caches invalidated
- Context switching overhead

**worktree-slots** gives you numbered "slots" that are independent worktrees of the same repo. Switch between branches instantly by just changing directories.

## Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/xpload32004/worktree-slots/main/install.sh | bash
```

### Manual

```bash
# Download
curl -o ~/.local/bin/worktree-slots https://raw.githubusercontent.com/xpload32004/worktree-slots/main/worktree-slots
chmod +x ~/.local/bin/worktree-slots

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
```

### From source

```bash
git clone https://github.com/xpload32004/worktree-slots.git
cd worktree-slots
./install.sh
```

## Quick Start

```bash
# 1. Configure where your repos live (optional, default: ~/repos)
mkdir -p ~/.config/worktree-slots
echo 'REPOS_DIR="$HOME/repos"' > ~/.config/worktree-slots/config

# 2. Clone a repo to your repos directory
cd ~/repos
git clone git@github.com:user/myproject.git
cd myproject

# 3. See available slots
worktree-slots status

# 4. Start working on a feature
worktree-slots use 1 feature/new-login
cd ~/repos/myproject-slot-1

# 5. Work on another branch in parallel
worktree-slots use 2 fix/bug-123
cd ~/repos/myproject-slot-2

# 6. When done, free up slots
worktree-slots free 1
```

## Commands

| Command | Description |
|---------|-------------|
| `status [project]` | Quick overview of all slots |
| `list [project]` | Detailed slot information |
| `use <slot> <branch>` | Create or switch a slot to a branch |
| `free <slot>` | Remove a worktree slot |
| `open <slot>` | Open slot in configured editor/terminal |
| `init [project]` | Initialize slots for a project |
| `config` | Show current configuration |
| `help` | Show help message |

## Configuration

Configuration file: `~/.config/worktree-slots/config`

```bash
# Where your git repos live
REPOS_DIR="$HOME/repos"

# Number of slots available (default: 5)
NUM_SLOTS=5

# For 'worktree-slots open' command:

# Option 1: Just an editor
OPEN_EDITOR="code"  # or nvim, vim, etc.

# Option 2: Terminal + editor (macOS)
OPEN_TERMINAL="iTerm"  # or Ghostty, Terminal
OPEN_EDITOR="nvim"

# Option 3: Full custom command
# Variables: $slot_dir, $branch, $project, $slot
OPEN_COMMAND='cd $slot_dir && code .'
```

### Environment Variables

These override config file settings:

- `WORKTREE_REPOS_DIR` - Override `REPOS_DIR`
- `WORKTREE_NUM_SLOTS` - Override `NUM_SLOTS`

## Directory Structure

Given `REPOS_DIR=~/repos` and a project called `myproject`:

```
~/repos/
├── myproject/           # Main repo (keep on main/master)
├── myproject-slot-1/    # Worktree for slot 1
├── myproject-slot-2/    # Worktree for slot 2
├── myproject-slot-3/    # Worktree for slot 3
└── ...
```

## Workflow Tips

1. **Keep main repo clean**: The main repo (`~/repos/myproject`) should stay on main/master for pulling updates.

2. **One branch per slot**: Each slot checks out a single branch. Use different slots for different features/MRs.

3. **Parallel development**: Run different IDE windows or terminal sessions per slot.

4. **Dotfile copying**: When creating a new slot, untracked dotfiles (like `.envrc`) are automatically copied from the main repo.

5. **Safe cleanup**: `worktree-slots free` checks for uncommitted changes before removing. Use `--force` to override.

## Requirements

- Git 2.5+ (for worktree support)
- Bash 4.0+

## License

MIT

## Contributing

Issues and PRs welcome at https://github.com/xpload32004/worktree-slots
