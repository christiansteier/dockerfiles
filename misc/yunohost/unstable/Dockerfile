FROM debian:stable-backports
LABEL maintainer="Christian-Maximilian Steier"

ARG INSTALL_TYPE=unstable
ARG BRANCHE_TYPE=stretch
ARG minimal_apt_get_install='apt-get install -y --no-install-recommends'
ENV DEBIAN_FRONTEND=noninteractive \
DEBCONF_NONINTERACTIVE_SEEN=true
ADD  docker-entrypoint.sh /docker-entrypoint.sh

RUN \
    # Cleanup Based on https://gist.github.com/jumanjiman/f9d3db977846c163df12 \
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
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
    echo "\n[i] Prepare System\n" && \
    # Do not cache apt packages (https://wiki.ubuntu.com/ReducingDiskFootprint) \
    echo 'Acquire::http {No-Cache=True;};' > /etc/apt/apt.conf.d/no-cache && \
    echo 'Dir::Cache { srcpkgcache ""; pkgcache ""; }' > /etc/apt/apt.conf.d/02nocache && \
    echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/02compress-indexes && \
    # Temporarily disable dpkg fsync to make building faster. \
    if [ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]; then echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ; fi && \
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
    # Install HTTPS support for APT.
    $minimal_apt_get_install apt-transport-https ca-certificates && \
    # Install add-apt-repository \
    $minimal_apt_get_install software-properties-common && \
    # Upgrade all packages. \
    apt-get dist-upgrade -y --no-install-recommends && \
    # Fix locale.
    $minimal_apt_get_install locales locales-all && \
    dpkg-reconfigure locales && \
    locale-gen "en_US.UTF-8" && \
    echo -n en_US.UTF-8 > /etc/container_environment/LANG && \
    # Systemd
    $minimal_apt_get_install systemd && \
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
    $minimal_apt_get_install wget curl apt-utils ssh openssl openssh-server neovim cron git && \
    # debug docker context for resolvconf
    echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections && \
    $minimal_apt_get_install resolvconf && \
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
