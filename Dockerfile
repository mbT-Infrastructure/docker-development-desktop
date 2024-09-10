FROM madebytimo/development

COPY files/locale.gen /etc/locale.gen
COPY --from=madebytimo/development-desktop:v0.0.1-base-2023-07-11 /opt/meshinstall.sh \
    /opt/meshinstall.sh

RUN apt update -qq && apt install -y -qq cinnamon dbus dbus-x11 xserver-xorg-video-dummy \
    && install-autonomous.sh install AndroidStudio Chromium DBeaver DesktopBasics Firefox \
    IntellijIdea ScriptsDesktop UnityHub VncServer VSCode \
    && rm -rf /var/lib/apt/lists/* \
    \
    && locale-gen \
    && chmod +x /opt/meshinstall.sh \
    && usermod --append --groups audio,video,plugdev,netdev,bluetooth,lp,scanner user \
    && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
    && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

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
