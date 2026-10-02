#!/bin/bash
# Merges the tmux-status hooks (tmux-status.hooks.json) into ~/.claude/settings.json.
# Idempotent: existing tmux-status entries are replaced, other hooks are kept.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS="$HOME/.claude/settings.json"
CMD="~/.claude/hooks/tmux-status.sh"

command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 1; }
[[ -f "$SETTINGS" ]] || echo '{}' >"$SETTINGS"

cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"

jq --arg cmd "$CMD" --slurpfile events "$DIR/tmux-status.hooks.json" '
  .hooks //= {}
  | .hooks |= with_entries(.value |= map(select(any(.hooks[]?; .command | startswith($cmd)) | not)))
  | reduce ($events[0] | to_entries[]) as $e (.;
      .hooks[$e.key] += [{"matcher": "", "hooks": [{"type": "command", "command": "\($cmd) \($e.value)", "async": true}]}])
  | .hooks |= with_entries(select(.value | length > 0))
' "$SETTINGS" >"$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"

echo "tmux-status hooks installed into $SETTINGS"
