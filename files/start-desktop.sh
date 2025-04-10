#!/usr/bin/env bash
set -e

PIDS=()

if [[ -n "$AUTHORIZED_PUBLIC_KEYS" ]]; then
    run-sshd.sh &
    PIDS+=("$!")
fi

echo "Creating virtual display."
rm -f /tmp/.X0-lock
Xorg "$DISPLAY" &
PIDS+=("$!")

echo "Start dbus."
dbus-daemon --address="$DBUS_SESSION_BUS_ADDRESS" --session &
PIDS+=("$!")

echo "Start desktop."
sudo --user user cinnamon-session &
PIDS+=("$!")

if [[ -n "$USER_PASSWORD" ]]; then
    echo "Start VNC server."
    x11vnc -forever -passwd "$USER_PASSWORD" -quiet -shared -xrandr &
    PIDS+=("$!")
fi

echo "Run Processes in pids ${PIDS[*]}."
wait -n -p PID_FAIL "${PIDS[@]}"
echo "Process with pid $PID_FAIL exited."
kill "${PIDS[@]}"
exit 1
