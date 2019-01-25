FROM php:7.2-stretch
LABEL maintainer="Christian-Maximilian Steier"

ARG minimal_apt_get_install='apt-get install -y --no-install-recommends'
ENV DEBIAN_FRONTEND=noninteractive \
DEBCONF_NONINTERACTIVE_SEEN=true

RUN \
    # Cleanup Based on https://gist.github.com/jumanjiman/f9d3db977846c163df12 \
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
    echo "[i] Remove all suid files." && \
    find $sysdirs -xdev -type f -a -perm -4000 -delete && \
    echo "[i] Remove other programs that could be dangerous." && \
    find $sysdirs -xdev \( -name hexdump -o -name chgrp -o -name od -o -name strings -o -name su \) -delete && \
    echo "[i] Remove unnecessary user accounts." && \
    for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody -ve daemon -ve www-data -ve nologin -ve _apt); do deluser "$user"; done && \
    for group in $(cat /etc/group | awk -F':' '{print $1}' | grep -ve root -ve nogroup -ve www-data -ve node -ve staff); do delgroup "$group"; done && \
    echo "[i] Remove interactive login shell" && \
    sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    \
    # Basics \
    echo "\n[i] Install basics\n" && \
    apt-get update && \
    $minimal_apt_get_install gnupg vim-tiny curl git-core unzip && \
    ln -s /usr/bin/vim.tiny /usr/bin/vim && \
    \
    # Composer \
    echo "\n[i] Install Composer\n" && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    \
    # Node and npm \
    echo "\n[i] Install Node and npm\n" && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install -y nodejs && \
    \
    # PHP \
    echo -e "\n[i] Install PHP-Extensions\n" && \
    mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini && \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)" && \
    docker-php-ext-install \
	mbstring \
	opcache \
	mysqli \
	pdo \
	tokenizer \
	xmlr \
	zip \
    # BotMan Studio
    echo "\n[i] Install BotMan Studio\n" && \
    echo "" >> /root/.bashrc && \
    echo "export PATH=\$HOME/.composer/vendor/bin:\$HOME/bin:/usr/local/bin:\$PATH" >> /root/.bashrc && \
    mkdir -p /var/www/studio && \
    composer create-project --prefer-dist botman/studio /var/www/studio

WORKDIR /var/www/studio
ENTRYPOINT ["/usr/local/bin/php", "-S", "0.0.0.0:80", "-t", "/var/www/studio/public"]
