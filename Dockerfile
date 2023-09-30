FROM madebytimo/development

RUN install-autonomous.sh install Chromium DesktopBasics Firefox GoogleChrome IntellijIdea \
    ScriptsDesktop UnityHub VSCode \
    && apt update -qq && apt install -y -qq cinnamon dbus dbus-x11 x11vnc xserver-xorg-video-dummy \
    && rm -rf /var/lib/apt/lists/*

COPY files/locale.gen /etc/locale.gen
COPY --from=madebytimo/development-desktop:v0.0.1-base-2023-07-11 /opt/meshinstall.sh \
    /opt/meshinstall.sh

RUN locale-gen \
    && chmod +x /opt/meshinstall.sh \
    && usermod --append --groups audio,video,plugdev,netdev,bluetooth,lp,scanner user \
    && echo "X11Forwarding yes" >> /etc/ssh/sshd_config \
    && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

COPY files/xorg-dummy.conf /app/templates/xorg-dummy.conf
COPY --chown=user files/autostart /media/user/.config/autostart

COPY files/start-desktop.sh /opt/start-desktop.sh

ENV DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/bus"
ENV DISPLAY_RESOLUTION="1280x720"
ENV DISPLAY=":0"
ENV LANG="de_DE.UTF-8"
ENV MESHCENTRAL_DOMAIN=""
ENV MESHCENTRAL_GROUP_ID=""
ENV USER_PASSWORD=""

RUN mv /entrypoint.sh /entrypoint-development.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/opt/start-desktop.sh" ]
