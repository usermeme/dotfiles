#!/bin/bash
# Colors the tmux window status of the pane running Claude Code.
# Usage (from Claude Code hooks): tmux-status.sh running|waiting|done|clear

cat >/dev/null # drain hook JSON from stdin

[[ -z "$TMUX_PANE" ]] && exit 0
command -v tmux >/dev/null 2>&1 || exit 0

set_style() {
    tmux set-option -w -t "$TMUX_PANE" window-status-style "$1" \; \
        set-option -w -t "$TMUX_PANE" @claude_state "$2"
}

case "$1" in
    running) set_style "bg=default,fg=colour3,bold" running ;; # yellow
    waiting) set_style "bg=default,fg=colour1,bold" waiting ;; # red
    done)
        # Already looking at this window: nothing to highlight
        if [[ "$(tmux display-message -p -t "$TMUX_PANE" '#{window_active}#{session_attached}')" == "11" ]]; then
            "$0" clear </dev/null
        else
            set_style "bg=default,fg=colour2,bold" done # green
        fi
        ;;
    clear)
        tmux set-option -wu -t "$TMUX_PANE" window-status-style \; \
            set-option -wu -t "$TMUX_PANE" @claude_state
        ;;
esac

exit 0
