FROM debian:stable-slim
LABEL maintainer="Christian-Maximilian Steier"

ARG minimal_apt_get_install='apt-get install -y --no-install-recommends'
ENV DEBIAN_FRONTEND=noninteractive \
DEBCONF_NONINTERACTIVE_SEEN=true

RUN \
    # Cleanup Based on https://gist.github.com/jumanjiman/f9d3db977846c163df12 \
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo -e "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
    echo "[i] Remove all suid files." && \
    find $sysdirs -xdev -type f -a -perm -4000 -delete && \
    echo "[i] Remove other programs that could be dangerous." && \
    find $sysdirs -xdev \( -name hexdump -o -name od -o -name strings -o -name su \) -delete && \
    echo "[i] Remove unnecessary user accounts." && \
    for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody -ve daemon -ve www-data -ve nologin -ve _apt); do deluser "$user"; done && \
    for group in $(cat /etc/group | awk -F':' '{print $1}' | grep -ve root -ve nogroup -ve www-data -ve node -ve staff); do delgroup "$group"; done && \
    echo "[i] Remove interactive login shell" && \
    sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    echo "[i] Remove broken symlinks." && \
    find $sysdirs -xdev -type l -exec test ! -e {} \; -delete && \
    \
    # Prepare \
    echo -e "\n[i] Prepare System\n" && \
    # Do not cache apt packages (https://wiki.ubuntu.com/ReducingDiskFootprint) \
    echo 'Acquire::http {No-Cache=True;};' > /etc/apt/apt.conf.d/no-cache && \
    echo 'Dir::Cache { srcpkgcache ""; pkgcache ""; }' > /etc/apt/apt.conf.d/02nocache && \
    echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/02compress-indexes && \
    # Temporarily disable dpkg fsync to make building faster. \
    if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ; fi && \
    # Prevent initramfs updates from trying to run grub and lilo (https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace) \
    export INITRD=no && \
    mkdir -p /etc/container_environment && \
    echo -n no > /etc/container_environment/INITRD && \
    # Fix some issues with APT packages (https://github.com/dotcloud/docker/issues/1024) \
    dpkg-divert --local --rename --add /sbin/initctl && \
    ln -sf /bin/true /sbin/initctl && \
    # Replace the 'ischroot' tool to make it always return true (https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/ and https://bugs.launchpad.net/launchpad/+bug/974584) \
    dpkg-divert --local --rename --add /usr/bin/ischroot && \
    ln -sf /bin/true /usr/bin/ischroot && \
    # The following security actions are recommended by some security scans (https://console.bluemix.net/docs/services/va/va_index.html) \
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    1/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password && \
    apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confdef" && \
    # Install HTTPS support for APT. \
    $minimal_apt_get_install apt-transport-https ca-certificates && \
    # Install add-apt-repository \
    $minimal_apt_get_install software-properties-common && \
    # Upgrade all packages. \
    apt-get dist-upgrade -y --no-install-recommends && \
    # Fix locale. \
    $minimal_apt_get_install locales && \
    dpkg-reconfigure locales && \
    locale-gen "en_US.UTF-8" && \
    echo -n en_US.UTF-8 > /etc/container_environment/LANG && \
    \
    # Services \
    echo -e "\n[i] Install s6-overlay\n" && \
    $minimal_apt_get_install curl gnupg && \
    GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161" && \
    S6OVERLAY=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi && \
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz && \
    curl -o /tmp/s6-overlay.tar.gz.sig -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz.sig && \
    curl https://keybase.io/justcontainers/key.asc | gpg --import && \
    FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" && \
    gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz && \
    if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi && \
    if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi && \
    echo "[i] All seems good, now unpacking s6-overlay.tar.gz" && \
    tar xzf /tmp/s6-overlay.tar.gz -C / && \
    echo -e "\n[i] Install cron\n" && \
    $minimal_apt_get_install cron && \
    \
    # Apache \
    $minimal_apt_get_install apache2 apache2-utils openssl && \
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
