FROM php:7.2-fpm-alpine
LABEL maintainer="Christian-Maximilian Steier"

ENV VERSION="3.17"
ARG RELEASE=".5+190604"
ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG PHP_ROOT_DIR=/usr/local/etc

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
    find $sysdirs -xdev -type f -a -perm +4000 -delete && \
    echo "[i] Remove other programs that could be dangerous." && \
    find $sysdirs -xdev \( -name hexdump -o -name chgrp -o -name ln -o -name od -o -name strings -o -name su \) -delete && \
    echo "[i] Remove unnecessary user accounts." && \
    for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody -ve daemon -ve www-data -ve nologin); do deluser "$user"; done && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    \
    # System tools \
    apk --no-cache add shadow curl gnupg grep tzdata coreutils rsync && \
    \
    # s6-overlay \
    echo -e "\n[i] Install s6-overlay\n" && \
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
    \
    # PHP \
    usermod -u 1000 ${WEB_USER} && \
    groupmod -g 1000 ${WEB_GROUP} && \
    sed -i 's*; display_errors*display_errors = off*g' $PHP_ROOT_DIR/php/php.ini-production && \
    sed -i 's*;catch_workers_output = yes*catch_workers_output = yes*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \ 
    sed -i 's*;php_flag[display_errors] = off*php_flag[display_errors] = off*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \
    sed -i 's*;php_admin_flag[log_errors] = on*php_admin_flag[log_errors] = on*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \
    sed -i 's*;php_admin_value[error_log] = /var/log/fpm-php.www.log*php_admin_value[error_log] = ${PHP_ROOT_DIR}/logs/error.log*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \
    sed -i 's*listen = 9000*listen = 0.0.0.0:9000*g' $PHP_ROOT_DIR/php-fpm.d/zz-docker.conf && \
    echo -e "\n[i] Install PHP-Extensions\n" && \
    apk add -U --no-cache freetype c-client icu-libs libevent libldap libpng libjpeg-turbo libmemcached libmcrypt postgresql-libs libzip && \
    apk add --no-cache --virtual build-dependencies \
	autoconf \
	build-base \
	freetype-dev \
	icu-dev \
	imap-dev \
	libevent-dev \
	libpng-dev \
	libjpeg-turbo-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libzip-dev \
	openldap-dev \
	postgresql-dev \
	zlib-dev && \
    mv $PHP_ROOT_DIR/php/php.ini-production $PHP_ROOT_DIR/php/php.ini && \
    pecl install mcrypt-1.0.2 && \
    docker-php-ext-enable mcrypt && \
    docker-php-ext-configure zip --with-libzip && \
    docker-php-ext-configure imap --with-imap --with-imap-ssl && \
    docker-php-ext-configure gd \
	--with-gd \
	--with-freetype-dir=/usr/include/ \
	--with-png-dir=/usr/include/ \
	--with-jpeg-dir=/usr/include/ && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
    docker-php-ext-install -j${NPROC} \
	gd \
	imap \
	intl \
	ldap \
	mysqli \
        pdo_mysql \
        pdo_pgsql \
	zip && \
    # Memcached, Redis, APCu \
    pecl install memcached redis apcu && \
    docker-php-ext-enable memcached redis apcu && \
    # set recommended PHP.ini settings \
    echo 'opcache.enable=1' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.enable_cli=1' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.interned_strings_buffer=8' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.max_accelerated_files=10000' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.memory_consumption=128' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.save_comments=1' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'opcache.revalidate_freq=1' >> $PHP_ROOT_DIR/php/conf.d/opcache-recommended.ini && \
    echo 'apc.enable_cli=1' >> $PHP_ROOT_DIR/php/conf.d/docker-php-ext-apcu.ini && \
    echo 'memory_limit=512M' > $PHP_ROOT_DIR/php/conf.d/memory-limit.ini && \
    sed -i 's*; display_errors*display_errors = off*g' $PHP_ROOT_DIR/php/php.ini && \
    apk del --purge build-dependencies grep shadow && \
    \
    # LimeSurvey \
    curl -o /tmp/limesurvey${VERSION}${RELEASE}.tar.gz -L https://download.limesurvey.org/latest-stable-release/limesurvey${VERSION}${RELEASE}.tar.gz && \
    cd /tmp && \
    tar zxvf  limesurvey${VERSION}${RELEASE}.tar.gz -C /usr/src && \
    rm *.tar.gz && \
    \
    # Cleanup
    rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/* /etc/fstab

# copy local files
COPY root/ /
ENTRYPOINT ["/init"]
