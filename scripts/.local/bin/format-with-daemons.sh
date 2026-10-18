#!/bin/bash

# Shared eslint_d + prettierd formatting pipeline for all agent hooks:
#   - Gemini CLI: after-tool-daemon-handler.sh (AfterTool hook)
#   - OpenCode:   formatter config in ~/.config/opencode/opencode.jsonc
#   - Cline:      ~/.cline/hooks/PostToolUse
#
# Usage: format-with-daemons.sh <file>
# Runs eslint_d --fix (JS family only), then prettierd in place.
# Always exits 0; failures are reported on stderr.

FILE_PATH="$1"

[[ -n "$FILE_PATH" && -f "$FILE_PATH" ]] || exit 0

# Only run the daemons on file types they are meant to handle.
eslint_target() {
    case "$1" in
        *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs) return 0 ;;
        *) return 1 ;;
    esac
}

prettier_target() {
    case "$1" in
        *.js|*.jsx|*.ts|*.tsx|*.mjs|*.cjs|*.json|*.jsonc|*.md|*.markdown|*.css|*.scss|*.less|*.html|*.htm|*.yml|*.yaml|*.vue|*.svelte|*.graphql|*.gql|*.xml) return 0 ;;
        *) return 1 ;;
    esac
}

# 1. Run ESLint Fix (lint before format)
if eslint_target "$FILE_PATH" && command -v eslint_d >/dev/null 2>&1; then
    if ! eslint_d --fix "$FILE_PATH" >/dev/null 2>&1; then
        echo "format-with-daemons: eslint_d --fix failed for $FILE_PATH" >&2
    fi
fi

# 2. Run Prettier (write to a temp file; keep the original on failure or empty output)
if prettier_target "$FILE_PATH" && command -v prettierd >/dev/null 2>&1; then
    TMP_FILE=$(mktemp "${TMPDIR:-/tmp}/prettierd.XXXXXX") || TMP_FILE=""
    if [[ -n "$TMP_FILE" ]] && prettierd "$FILE_PATH" > "$TMP_FILE" 2>/dev/null && [[ -s "$TMP_FILE" ]]; then
        # cat (not mv): preserves the original inode, permissions, and executable bit
        cat "$TMP_FILE" > "$FILE_PATH"
    fi
    [[ -n "$TMP_FILE" ]] && rm -f "$TMP_FILE"
fi

exit 0
