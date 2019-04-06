FROM bitnami/minideb:stretch
LABEL maintainer="Christian-Maximilian Steier"

ARG INSTALL_TYPE=stable
ARG BRANCHE_TYPE=stretch
ADD docker-entrypoint.sh /docker-entrypoint.sh

RUN \
    # Prepare \
    echo "\n[i] Prepare System\n" && \
    # Upgrade all packages.
    apt-get update && \
    apt-get dist-upgrade -y --no-install-recommends && \
    # Install HTTPS support for APT.
    install_packages apt-transport-https ca-certificates && \
    # Install add-apt-repository \
    install_packages software-properties-common && \
    # Fix locale.
    install_packages locales locales-all && \
    dpkg-reconfigure locales && \
    locale-gen "en_US.UTF-8" && \
    # Systemd
    install_packages systemd && \
    rm -f \
      /lib/systemd/system/multi-user.target.wants/* \
      /etc/systemd/system/*.wants/* \
      /lib/systemd/system/local-fs.target.wants/* \
      /lib/systemd/system/sockets.target.wants/*udev* \
      /lib/systemd/system/sockets.target.wants/*initctl* \
      /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* \
      /lib/systemd/system/systemd-update-utmp* && \
    \
    # Yunohost
    install_packages wget curl apt-utils ssh openssl openssh-server cron git && \
    # debug docker context for resolvconf
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \
    install_packages resolvconf && \
    # get yunohost git repo
    git clone -b $BRANCHE_TYPE https://github.com/YunoHost/install_script /yunohost-git && \
    git -C /yunohost-git checkout $BRANCHE_TYPE && \
    # hack YunoHost install_script for bypass systemd check
    sed -i "s@/run/systemd/system@/run@g" /yunohost-git/install_yunohost && \
    /yunohost-git/install_yunohost -a -d $INSTALL_TYPE && \
    # force ulimit for slapd
    sed -i '/\/lib\/lsb\/init-functions/a ulimit -n 1024' /etc/init.d/slapd && \
    rm -rf /yunohost-git && \
    \
    apt-get clean && \
    rm -rf \
      /etc/machine-id \
      /var/lib/dbus/machine-id \
      /var/lib/apt/lists/* \
      /var/log/alternatives.log \
      /var/log/apt/history.log \
      /var/log/apt/term.log \
      /var/log/dpkg.log \
      /etc/dpkg/dpkg.cfg.d/02apt-speedup \
      /var/cache/ldconfig/aux-cache \
      /usr/share/doc \
      /usr/share/man/ \
      /usr/share/info/* \
      /var/cache/man/* \
      /tmp/* \
      /scripts && \
    \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
VOLUME ["/sys/fs/cgroup"]
# A different stop signal is required, so systemd will initiate a shutdown when
# running 'docker stop <container>'.
STOPSIGNAL SIGRTMIN+3
CMD ["/lib/systemd/systemd"]
