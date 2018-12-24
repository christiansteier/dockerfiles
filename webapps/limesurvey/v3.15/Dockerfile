FROM php:7.1-fpm-alpine
LABEL maintainer="Christian-Maximilian Steier"

ENV VERSION="3.15"
ARG RELEASE=".5+181115"

ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG PHP_ROOT_DIR=/usr/local/etc

RUN apk --no-cache add shadow curl gnupg grep tzdata coreutils rsync && \
    usermod -u 1000 ${WEB_USER} && \
    groupmod -g 1000 ${WEB_GROUP} && \
    sed -i 's*; display_errors*display_errors = off*g' $PHP_ROOT_DIR/php/php.ini-production && \
    sed -i 's*;catch_workers_output = yes*catch_workers_output = yes*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \ 
    sed -i 's*;php_flag[display_errors] = off*php_flag[display_errors] = off*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \
    sed -i 's*;php_admin_flag[log_errors] = on*php_admin_flag[log_errors] = on*g' $PHP_ROOT_DIR/php-fpm.d/www.conf && \
    sed -i 's*;php_admin_value[error_log] = /var/log/fpm-php.www.log*php_admin_value[error_log] = ${PHP_ROOT_DIR}/logs/error.log*g' $PHP_ROOT_DIR/php-fpm.d/www.conf

# s6-overlay
RUN echo -e "\n[i] Install s6-overlay\n" && \
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
tar xzf /tmp/s6-overlay.tar.gz -C /

# socklog-overlay
RUN echo -e "\n[i] Install socklog-overlay\n" && \
    SOCKLOG=$(curl -s https://api.github.com/repos/just-containers/socklog-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi && \
    curl -o /tmp/socklog-overlay-${ARCHTAG}.tar.gz -L https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOG}/socklog-overlay-${ARCHTAG}.tar.gz && \
    tar xzf /tmp/socklog-overlay-${ARCHTAG}.tar.gz -C /

# PHP
RUN echo -e "\n[i] Install PHP-Extensions\n" && \
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
	hash \
	imap \
	intl \
	ldap \
	mbstring \
	mcrypt \
	mysqli \
        pdo_mysql \
        pdo_pgsql \
	session \
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
    sed -i 's*; display_errors*display_errors = off*g' $PHP_ROOT_DIR/php/php.ini

# LimeSurvey
ADD https://download.limesurvey.org/latest-stable-release/limesurvey${VERSION}${RELEASE}.tar.gz /tmp/limesurvey${VERSION}${RELEASE}.tar.gz
RUN cd /tmp && \
    tar zxvf  limesurvey${VERSION}${RELEASE}.tar.gz -C /usr/src && \
    rm *.tar.gz

# copy local files
COPY root/ /

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/5317638ec64c0e8c3d22cd9965237a452bf82895/docker-alpine-cleanup.sh && \
    chmod +x /tmp/cleanup.sh && \
    apk del --purge build-dependencies grep curl shadow && \
    /tmp/cleanup.sh
ENTRYPOINT ["/init"]
