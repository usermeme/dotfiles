# Dotfiles

My personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [jq](https://jqlang.github.io/jq/) (only for installing the Claude Code hooks)

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:usermeme/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Use GNU Stow to symlink the configurations:
   ```bash
   stow claude
   stow gemini
   stow ghostty
   stow nvim
   stow scripts
   stow tmux
   ```

   Or stow everything at once:
   ```bash
   stow */
   ```

3. (Optional, only if Claude Code is installed) Merge the Claude Code hooks into `~/.claude/settings.json`:
   ```bash
   ~/.claude/hooks/install-hooks.sh
   ```
   Safe to re-run: it replaces its own entries, keeps any other hooks and backs up the file first.

## Claude Code tmux status

`claude/.claude/hooks/tmux-status.sh` colors the tmux window that runs Claude Code:

| State | Color | Claude Code event |
|---|---|---|
| Running | yellow | `UserPromptSubmit`, `PostToolUse` |
| Needs input | red | `PermissionRequest`, `Notification` |
| Done | green | `Stop` |
| Reset | default | `SessionEnd` |

The color shows only on non-active windows. The green "done" highlight clears when you switch to that window, via the `after-select-window` hook in `tmux/.tmux.conf`. On machines without Claude Code the hook is a no-op.

To change which events map to which state, edit `claude/.claude/hooks/tmux-status.hooks.json` and re-run `install-hooks.sh`.

## Structure

- `claude/`: Claude Code hooks (tmux window status)
- `gemini/`: Gemini CLI configuration
- `ghostty/`: Ghostty terminal configuration
- `nvim/`: Neovim configuration
- `scripts/`: Custom shell scripts
- `tmux/`: Tmux configuration
