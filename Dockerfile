FROM madebytimo/development

ARG MESHCENTRAL_URL

COPY files/locale.gen /etc/locale.gen

RUN apt update -qq && apt install -y -qq cinnamon dbus dbus-x11 xserver-xorg-video-dummy \
    && install-autonomous.sh install AndroidStudio Chromium DBeaver DesktopBasics Firefox \
    IntellijIdea ScriptsDesktop UnityHub VncServer VSCode \
    && rm -rf /var/lib/apt/lists/* \
    \
    && locale-gen \
    && usermod --append --groups audio,video,plugdev,netdev,bluetooth,lp,scanner user \
    && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
    && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && download.sh --silent --output /opt/meshinstall.sh \
        "https://${MESHCENTRAL_URL#*://}/meshagents?script=1" \
    && chmod +x /opt/meshinstall.sh

COPY files/xorg-dummy.conf /app/templates/xorg-dummy.conf
COPY --chown=user files/autostart /media/user/.config/autostart

ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/bus"
ENV DISPLAY_RESOLUTION="1280x720"
ENV DISPLAY=":0"
ENV LANG="de_DE.UTF-8"
ENV MESHCENTRAL_DOMAIN=""
ENV MESHCENTRAL_GROUP_ID=""
ENV USER_PASSWORD=""

RUN mv /entrypoint.sh /entrypoint-development.sh
COPY files/entrypoint.sh files/start-desktop.sh /usr/local/bin/

ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "start-desktop.sh" ]
