# =============================================================================
# Basics
# =============================================================================
# Keep PATH free of duplicates (nested shells: tmux, nvim :terminal, ...)
typeset -U path PATH

# Prepend / append only directories that actually exist on this machine
path_prepend() { local d; for d in "$@"; do [[ -d $d ]] && path=("$d" $path); done; }
path_append()  { local d; for d in "$@"; do [[ -d $d ]] && path+=("$d"); done; }

# =============================================================================
# Homebrew & Core
# =============================================================================
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
: ${HOMEBREW_PREFIX:=/opt/homebrew}

path_prepend "$HOMEBREW_PREFIX/opt/curl/bin" "$HOME/.local/bin"

# =============================================================================
# ZSH Completion & Prompt
# =============================================================================
autoload -Uz compinit && compinit

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '[%b]'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]'
precmd_functions+=(vcs_info)

setopt PROMPT_SUBST
# user@host  cwd  [branch]
# %%
PROMPT='%F{243}%n@%M %F{197}%~ %F{39}${vcs_info_msg_0_}%f'$'\n''%% '

# =============================================================================
# Node / NVM / PNPM / Yarn
# =============================================================================
export NVM_DIR="$HOME/.nvm"
_nvm_sh="$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
if [[ -s $_nvm_sh ]]; then
  # Put the default node on PATH without loading nvm (keeps startup fast).
  # Uses the version from `nvm alias default` when it is a number,
  # otherwise the newest installed version.
  _nvm_default=""
  [[ -r $NVM_DIR/alias/default ]] && _nvm_default=$(<"$NVM_DIR/alias/default")
  _nvm_default=${_nvm_default#v}
  [[ $_nvm_default == [0-9]* ]] || _nvm_default=""
  _nvm_bins=( "$NVM_DIR"/versions/node/v${_nvm_default}*/bin(N/nOn) )
  (( ${#_nvm_bins} )) && path_prepend "${_nvm_bins[1]}"

  # Load the real nvm only the first time it is called
  nvm() {
    unfunction nvm
    source "$_nvm_sh"
    nvm "$@"
  }
  unset _nvm_default _nvm_bins
fi

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
path_prepend "$PNPM_HOME" "$PNPM_HOME/bin"

# yarn
path_prepend "$HOME/.config/yarn/global/node_modules/.bin" "$HOME/.yarn/bin"

# =============================================================================
# Python / Pyenv
# =============================================================================
# pyenv manages python; it goes ahead of Homebrew's python3.
export PYENV_ROOT="$HOME/.pyenv"
path_prepend "$PYENV_ROOT/bin"
if (( $+commands[pyenv] )); then
  eval "$(pyenv init - zsh)"
fi

# =============================================================================
# Ruby / Rbenv
# =============================================================================
path_prepend "$HOMEBREW_PREFIX/opt/ruby/bin"
if (( $+commands[rbenv] )); then
  eval "$(rbenv init - zsh)"
fi

# =============================================================================
# Java / Android
# =============================================================================
# Pin JDK 17 so JAVA_HOME and the `java` on PATH always match.
if [[ -d $HOMEBREW_PREFIX/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home ]]; then
  export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
elif [[ -x /usr/libexec/java_home ]] && _jh=$(/usr/libexec/java_home -v 17 2>/dev/null); then
  export JAVA_HOME="$_jh"
fi
unset _jh
[[ -n $JAVA_HOME ]] && path_prepend "$JAVA_HOME/bin"

export ANDROID_HOME="$HOME/Library/Android/sdk"
path_append "$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools"

# =============================================================================
# AI Agents & CLI Tools (Antigravity, OpenCode, Devcontainers, Kilo)
# =============================================================================
path_prepend \
  "$HOME/.antigravity/antigravity/bin" \
  "$HOME/.opencode/bin" \
  "$HOME/.devcontainers/bin" \
  "$HOME/.kilo/bin"

# =============================================================================
# Puppeteer / Playwright
# =============================================================================
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
if (( $+commands[chromium] )); then
  export PUPPETEER_EXECUTABLE_PATH="$commands[chromium]"
fi

# =============================================================================
# Application Shortcuts
# =============================================================================
cursor() {
  open -a "/Applications/Cursor.app" "$@"
}

# =============================================================================
# Machine-local overrides & secrets (not tracked in git)
# =============================================================================
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"
