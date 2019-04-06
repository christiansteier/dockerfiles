FROM bitnami/minideb:stretch
LABEL maintainer="Christian-Maximilian Steier"

RUN \
    apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confdef" && \
    # Install HTTPS support for APT. \
    install_packages apt-transport-https ca-certificates && \
    # Install add-apt-repository \
    install_packages software-properties-common && \
    \
    # Services \
    echo "\n[i] Install s6-overlay\n" && \
    install_packages curl gnupg && \
    GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161" && \
    S6OVERLAY=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    if [ $(uname -m) = "armv6l" ] || [ $(uname -m) = "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) = "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) = "x86_64" ]; then ARCHTAG=amd64 ; fi && \
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz && \
    curl -o /tmp/s6-overlay.tar.gz.sig -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz.sig && \
    curl https://keybase.io/justcontainers/key.asc | gpg --import && \
    FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" && \
    gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz && \
    if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi && \
    if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi && \
    echo "[i] All seems good, now unpacking s6-overlay.tar.gz" && \
    tar xzf /tmp/s6-overlay.tar.gz -C / && \
    \
    # Apache \
    install_packages apache2 apache2-utils openssl && \
    echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf && \
    a2enconf servername && \
    a2dissite 000-default && \
    \
    # Cleanup \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /etc/dpkg/dpkg.cfg.d/02apt-speedup /etc/ssh/ssh_host_* /var/cache/ldconfig/aux-cache /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/* /etc/fstab /scripts

# copy local files
COPY root/ /
ENTRYPOINT ["/init"]
