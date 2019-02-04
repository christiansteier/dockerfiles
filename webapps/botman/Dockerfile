FROM php:7.3-alpine
LABEL maintainer="Christian-Maximilian Steier"

RUN \
    # Cleanup Based on https://gist.github.com/jumanjiman/f9d3db977846c163df12
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo -e "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
    echo "[i] Remove all suid files." && \
    find $sysdirs -xdev -type f -a -perm +4000 -delete && \
    echo "[i] Remove other programs that could be dangerous." && \
    find $sysdirs -xdev \( -name hexdump -o -name chgrp -o -name od -o -name strings -o -name su \) -delete && \
    echo "[i] Remove unnecessary user accounts." && \
    for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody -ve daemon -ve www-data -ve nologin); do deluser "$user"; done && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    \
    # Basics
    echo -e "\n[i] Install basics\n" && \
    apk --no-cache -U add gnupg vim curl git unzip && \
    \
    # Composer
    echo -e "\n[i] Install Composer\n" && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    \
    # Node and npm
    echo -e "\n[i] Install Node\n" && \
    apk --no-cache add nodejs nodejs-npm && \
    \
    # BotMan Studio
    echo -e "\n[i] Install BotMan Studio\n" && \
    echo "" >> /root/.bashrc && \
    echo "export PATH=\$HOME/.composer/vendor/bin:\$HOME/bin:/usr/local/bin:\$PATH" >> /root/.bashrc && \
    mkdir -p /var/www/studio && \
    composer create-project --prefer-dist botman/studio /var/www/studio

WORKDIR /var/www/studio
ENTRYPOINT ["/usr/local/bin/php", "-S", "0.0.0.0:80", "-t", "/var/www/studio/public"]

