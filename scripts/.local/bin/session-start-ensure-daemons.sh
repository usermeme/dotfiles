#!/bin/bash

ensure_daemon() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "$1 is available." >&2
    else
        echo "$1 not found. Please ensure it is installed globally." >&2
    fi
}

ensure_daemon "eslint_d"
ensure_daemon "prettierd"

echo "{}"
