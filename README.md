# worktree-slots

A simple CLI to manage git worktrees as numbered "slots" for parallel development.

## The Problem

Git worktrees are powerful—they let you have multiple branches checked out simultaneously in separate directories. But managing them manually is tedious:

```bash
# Without worktree-slots: manual worktree management
git worktree add ../myproject-feature-login feature/login
git worktree add ../myproject-fix-auth-bug fix/auth-bug
git worktree add ../myproject-review-api-refactor review/api-refactor

# Where was that branch again?
ls ../myproject-*
# Which one has uncommitted changes?
# Which one can I delete?
```

You end up with inconsistent naming, scattered directories, and mental overhead tracking what's where. And when you're juggling multiple features, bug fixes, and code reviews, this friction adds up.

**The alternative—branch switching—is worse:**
- Stash changes, switch, unstash, repeat
- IDE reindexes everything on each switch
- Build caches invalidated
- Tests need to rerun
- Context switching overhead

## The Solution

**worktree-slots** gives you numbered slots (1-5 by default) that handle all the worktree plumbing:

```bash
# With worktree-slots: simple numbered slots
worktree-slots use 1 feature/login
worktree-slots use 2 fix/auth-bug
worktree-slots use 3 review/api-refactor

# See what's where
worktree-slots status
# myproject slots:
#   1: feature/login
#   2: fix/auth-bug *        (* = uncommitted changes)
#   3: review/api-refactor
#   4: (empty)
#   5: (empty)

# Switch slot 3 to a different branch
worktree-slots use 3 hotfix/urgent

# Done with a branch? Free up the slot
worktree-slots free 1
```

No more thinking about directory names or paths. Just "slot 1", "slot 2", etc.

## Features

- **Numbered slots** - Up to N worktrees per project (default: 5), no naming required
- **Quick status** - See all slots, branches, and uncommitted changes at a glance
- **Smart branch handling** - Creates new branches if they don't exist, tracks remotes automatically
- **Configurable `open` command** - Launch your editor/terminal/tmux setup with one command
- **Auto-copies dotfiles** - Untracked files (`.envrc`, `.gitignore/`, etc.) copied to new slots
- **Safe cleanup** - Warns about uncommitted changes before removing slots
- **XDG-compliant config** - Settings in `~/.config/worktree-slots/config`
- **Zero dependencies** - Just bash and git

## Installation

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/xpload32004/worktree-slots/main/install.sh | bash
```

### Manual

```bash
curl -o ~/.local/bin/worktree-slots https://raw.githubusercontent.com/xpload32004/worktree-slots/main/worktree-slots
chmod +x ~/.local/bin/worktree-slots

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
```

### From source

```bash
git clone https://github.com/xpload32004/worktree-slots.git
cd worktree-slots
./install.sh
```

## Quick Start

```bash
# 1. Set up your config (optional)
mkdir -p ~/.config/worktree-slots
cat > ~/.config/worktree-slots/config << 'EOF'
REPOS_DIR="$HOME/projects"
OPEN_EDITOR="code"  # or nvim, vim, etc.
EOF

# 2. From inside any git repo
cd ~/projects/myproject
worktree-slots status          # See all slots

# 3. Start working on a feature
worktree-slots use 1 feature/new-dashboard
worktree-slots open 1          # Opens in your configured editor

# 4. Need to review a PR? Use another slot
worktree-slots use 2 fix/login-bug
worktree-slots open 2          # Opens in a separate editor window

# 5. Done with a branch? Clean up
worktree-slots free 1
```

## How It Works

Given a repo at `~/repos/myproject`, worktree-slots creates:

```
~/repos/
├── myproject/           # Main repo (keep on main/master for pulling)
├── myproject-slot-1/    # Worktree for slot 1
├── myproject-slot-2/    # Worktree for slot 2
├── myproject-slot-3/    # Worktree for slot 3
├── myproject-slot-4/    # Worktree for slot 4
└── myproject-slot-5/    # Worktree for slot 5
```

Each slot is a full git worktree—independent working directory, same repo. Changes in one slot don't affect others. Commits are shared (same `.git`).

## Commands

| Command | Description |
|---------|-------------|
| `status [project]` | Quick overview of all slots |
| `list [project]` | Detailed slot info (branch, status, path) |
| `use <slot> <branch>` | Create or switch a slot to a branch |
| `free <slot>` | Remove a worktree slot (`--force` to discard changes) |
| `open <slot>` | Open slot in configured editor/terminal |
| `config` | Show current configuration |
| `help` | Show help message |

## Configuration

Config file: `~/.config/worktree-slots/config`

```bash
# Where your git repos live
REPOS_DIR="$HOME/repos"

# Number of slots (default: 5)
NUM_SLOTS=5

# Configure 'worktree-slots open <slot>' behavior:

# Option 1: Just an editor
OPEN_EDITOR="code"  # or nvim, vim, etc.

# Option 2: Terminal + editor (macOS)
OPEN_TERMINAL="iTerm"  # or Ghostty, Terminal
OPEN_EDITOR="nvim"

# Option 3: Full custom command (variables: $slot_dir, $branch, $project, $slot)
OPEN_COMMAND='cd $slot_dir && code .'
```

### Environment Variables

Override config settings:

- `WORKTREE_REPOS_DIR` - Override `REPOS_DIR`
- `WORKTREE_NUM_SLOTS` - Override `NUM_SLOTS`

## Workflow Tips

1. **Keep main repo on main/master** - Use it for `git pull` to fetch updates, not for development.

2. **One branch per slot** - Each slot is one worktree. Context switch by changing directories, not branches.

3. **Run separate IDE/terminal per slot** - VS Code, nvim, etc. each pointing at a different slot directory.

4. **Dotfiles are copied automatically** - Untracked files like `.envrc` are copied from the main repo when creating a new slot.

5. **Safe cleanup** - `worktree-slots free` warns about uncommitted changes. Use `--force` to discard.

## Example: Parallel Development Workflow

```bash
# Morning: Start feature work
cd ~/repos/backend
worktree-slots use 1 feature/user-preferences
worktree-slots open 1  # Opens your configured editor/terminal

# Teammate asks for PR review
worktree-slots use 2 teammate/api-refactor
worktree-slots open 2  # Opens in a new window - slot 1 untouched

# Urgent bug reported
worktree-slots use 3 hotfix/login-crash
worktree-slots open 3  # Fix, commit, push, PR merged

# Clean up hotfix slot
worktree-slots free 3

# Back to feature work - slot 1 window is still open, nothing changed
```

## Requirements

- Git 2.5+ (worktree support)
- Bash 4.0+
- macOS or Linux

## License

MIT

## Contributing

Issues and PRs welcome at https://github.com/xpload32004/worktree-slots
