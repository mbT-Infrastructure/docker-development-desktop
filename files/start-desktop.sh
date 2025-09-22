#!/usr/bin/env bash
set -e -o pipefail

PIDS=()

if [[ -n "$AUTHORIZED_PUBLIC_KEYS" ]]; then
    run-sshd.sh &
    PIDS+=("$!")
fi

echo "Creating virtual display."
export XDG_SESSION_TYPE=x11
rm -f /tmp/.X0-lock
Xorg "$DISPLAY" &
PIDS+=("$!")

echo "Start dbus."
sudo --user user dbus-daemon --address="$DBUS_SESSION_BUS_ADDRESS" --fork --nopidfile --session

echo "Start desktop."
sudo --preserve-env=DBUS_SESSION_BUS_ADDRESS,XDG_SESSION_TYPE --user user \
    cinnamon-session &
PIDS+=("$!")

if [[ -n "$USER_PASSWORD" ]]; then
    echo "Start VNC server."
    vnc-server.sh --password "$USER_PASSWORD" --read-write &
    PIDS+=("$!")
fi

echo "Run Processes in pids ${PIDS[*]}."
wait -n -p PID_FAIL "${PIDS[@]}"
echo "Process with pid $PID_FAIL exited."
kill "${PIDS[@]}"
exit 1
