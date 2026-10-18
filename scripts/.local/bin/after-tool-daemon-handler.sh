#!/bin/bash

# Gemini CLI AfterTool hook: extract file_path from the hook JSON on stdin,
# then delegate to the shared daemon formatter (format-with-daemons.sh).

# Extract file_path from the hook JSON on stdin.
# Prefer jq (robust to nesting and pretty-printing); fall back to a
# whitespace-tolerant grep/cut when jq is unavailable or fails.
INPUT=$(cat)

FILE_PATH=""
if command -v jq >/dev/null 2>&1; then
    FILE_PATH=$(printf '%s' "$INPUT" | jq -r '[.. | objects | .file_path? // empty | strings] | .[0] // empty' 2>/dev/null)
fi
if [[ -z "$FILE_PATH" ]]; then
    FILE_PATH=$(printf '%s' "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | cut -d'"' -f4)
fi

if [[ -n "$FILE_PATH" ]]; then
    # Resolve the shared formatter next to this script (works through the
    # ~/.local/bin stow symlinks and from the repo directly).
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
    FORMATTER="$SCRIPT_DIR/format-with-daemons.sh"
    if [[ -x "$FORMATTER" ]]; then
        "$FORMATTER" "$FILE_PATH"
    else
        format-with-daemons.sh "$FILE_PATH"
    fi
fi

echo "{}"
