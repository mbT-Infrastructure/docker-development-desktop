FROM madebytimo/development

RUN install-autonomous.sh install Firefox GoogleChrome IntellijIdea UnityHub VSCode

RUN echo "X11Forwarding yes" >> /etc/ssh/sshd_config && \
    echo "X11UseLocalhost no" >> /etc/ssh/sshd_config
