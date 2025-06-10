#!/usr/bin/env bash
set -e -o pipefail

MODELINE="$(gtf "${DISPLAY_RESOLUTION%x*}" "${DISPLAY_RESOLUTION#*x}" 60 \
    | sed --silent 's/^\s*\(Modeline .*\)$/\1/p')"
export MODELINE

replace-vars.sh /app/templates/xorg-dummy.conf > /etc/X11/xorg.conf.d/xorg-dummy.conf

if [[ -n "$MESHCENTRAL_DOMAIN" ]] && [[ -n "$MESHCENTRAL_GROUP_ID" ]]; then
    echo "Connecting to meshcentral."
    /opt/meshinstall.sh "$MESHCENTRAL_DOMAIN" "$MESHCENTRAL_GROUP_ID"
    rm meshagent meshagent.msh
fi

exec entrypoint-development.sh "$@"
