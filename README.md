# Dotfiles

My personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
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

3. Install the Claude Code hooks (colors the tmux window status while Claude runs / when it's done):
   ```bash
   ~/.claude/hooks/install-hooks.sh
   ```

## Structure

- `claude/`: Claude CLI configuration
- `gemini/`: Gemini CLI configuration
- `ghostty/`: Ghostty terminal configuration
- `nvim/`: Neovim configuration
- `scripts/`: Custom shell scripts
- `tmux/`: Tmux configuration
