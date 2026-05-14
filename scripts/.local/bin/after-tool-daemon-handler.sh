#!/bin/bash

# Extract file_path using grep and cut for zero-overhead parsing
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path":"[^"]*"' | head -n 1 | cut -d'"' -f4)

if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
    # 1. Run ESLint Fix
    eslint_d --fix "$FILE_PATH" >/dev/null 2>&1 || true
    
    # 2. Run Prettier
    prettierd "$FILE_PATH" > "${FILE_PATH}.tmp" 2>/dev/null
    
    if [[ -s "${FILE_PATH}.tmp" ]]; then
        mv "${FILE_PATH}.tmp" "$FILE_PATH"
    else
        rm -f "${FILE_PATH}.tmp"
    fi
fi

echo "{}"
