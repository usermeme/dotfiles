# Dotfiles

My personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)
- [jq](https://jqlang.github.io/jq/) (Claude Code hook installation; Cline hooks; optional for the Gemini CLI hook)

## Installation

1. Clone the repository:
   ```bash
   git clone git@github.com:usermeme/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Use GNU Stow to symlink the configurations:
   ```bash
   stow claude
   stow cline
   stow gemini
   stow ghostty
   stow nvim
   stow opencode
   stow scripts
   stow tmux
   stow zsh
   ```

   If `~/.zshrc` already exists as a regular file, move it aside first (`mv ~/.zshrc ~/.zshrc.bak`), otherwise stow will refuse to link it. Put machine-specific settings and secrets in `~/.zshrc.local` (untracked, sourced at the end of `.zshrc`).

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

## Agent formatting daemons (eslint_d + prettierd)

`scripts/.local/bin/format-with-daemons.sh` is the shared pipeline: `eslint_d --fix`
(JS/TS only), then `prettierd` in place (inode, permissions, and executable bit are
preserved; the original file is kept if a daemon fails). It is wired into every agent:

| Agent | Mechanism | Files |
|---|---|---|
| Gemini CLI | `AfterTool` hook (`write_file\|replace`) + `SessionStart` check | `gemini/.gemini/settings.json`, `scripts/.local/bin/after-tool-daemon-handler.sh`, `session-start-ensure-daemons.sh` |
| OpenCode | native `formatter` config (runs after `write`/`edit`/`patch` tools) | `opencode/.config/opencode/opencode.jsonc` |
| Cline | `PostToolUse` + `TaskStart` file hooks in `~/.cline/hooks/` | `cline/.cline/hooks/` |

Notes:

- The daemons start themselves on first use; the session/task-start hooks only report availability.
- `~/.config/opencode/opencode.json` (provider settings incl. API keys) is machine-local and NOT tracked here; OpenCode merges it with the tracked `opencode.jsonc`.
- In Cline's VS Code extension, hooks must be enabled under Feature Settings → "Enable Hooks" (extension hooks are read from `~/Documents/Cline/Hooks/`; the tracked `~/.cline/hooks/` covers the CLI).

## Structure

- `claude/`: Claude Code hooks (tmux window status)
- `cline/`: Cline hooks (eslint/prettier daemons)
- `gemini/`: Gemini CLI configuration
- `ghostty/`: Ghostty terminal configuration
- `nvim/`: Neovim configuration
- `opencode/`: OpenCode configuration (formatter only; secrets stay machine-local)
- `scripts/`: Custom shell scripts
- `tmux/`: Tmux configuration
- `zsh/`: Zsh configuration (prompt, PATH, language toolchains; local overrides in `~/.zshrc.local`)
