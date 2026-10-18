#!/bin/bash

# The daemons start themselves on first invocation; this only checks
# that the binaries are installed and on PATH.
ensure_daemon() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "$1 is installed (daemon starts on first use)." >&2
    else
        echo "$1 not found. Please ensure it is installed globally." >&2
    fi
}

ensure_daemon "eslint_d"
ensure_daemon "prettierd"

echo "{}"
