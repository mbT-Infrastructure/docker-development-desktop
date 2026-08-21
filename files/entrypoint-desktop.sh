#!/usr/bin/env bash
set -e -o pipefail

if [[ "$EUID" == 0 ]]; then
    MODELINE="$(gtf "${DISPLAY_RESOLUTION%x*}" "${DISPLAY_RESOLUTION#*x}" 60 \
        | sed --silent 's/^\s*\(Modeline .*\)$/\1/p')"
    export MODELINE

    replace-vars.sh /app/templates/xorg-dummy.conf > /etc/X11/xorg.conf.d/xorg-dummy.conf
fi

if [[ -n "$MESHCENTRAL_DOMAIN" ]] && [[ -n "$MESHCENTRAL_GROUP_ID" ]]; then
    echo "Connecting to meshcentral."
    /opt/meshinstall.sh "$MESHCENTRAL_DOMAIN" "$MESHCENTRAL_GROUP_ID"
    rm meshagent meshagent.msh
fi

cat <<EOF > /etc/profile.d/env-desktop.sh
#!/usr/bin/env bash

DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS"
DISPLAY="$DISPLAY"
LANG="$LANG"


export DBUS_SESSION_BUS_ADDRESS DISPLAY LANG
EOF

exec entrypoint-development.sh "$@"
