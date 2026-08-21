#!/usr/bin/env bash
set -e -o pipefail

if [[ -n "$USER_PASSWORD" ]]; then
    nc -z localhost 5900 || exit 1
fi

if [[ -n "$DISPLAY" ]]; then
    xrandr --listmonitors &>/dev/null || exit 1
fi
