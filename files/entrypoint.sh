#!/usr/bin/env bash
set -e

sed --expression "s|###DISPLAY_RESOLUTION###|${DISPLAY_RESOLUTION}|g" \
    /app/templates/xorg-dummy.conf > /etc/X11/xorg.conf.d/xorg-dummy.conf

if [[ -n "$MESHCENTRAL_DOMAIN" ]] && [[ -n "$MESHCENTRAL_GROUP_ID" ]]; then
    echo "Connecting to meshcentral."
    /opt/meshinstall.sh "$MESHCENTRAL_DOMAIN" "$MESHCENTRAL_GROUP_ID"
    rm meshagent meshagent.msh
fi

entrypoint-development.sh "$@"
