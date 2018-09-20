FROM lsiobase/alpine.nginx.ARCHTAG:3.7
MAINTAINER Christian-Maxilian Steier

ARG VERSION=14.0.0
ARG GPG="2880 6A87 8AE4 23A2 8372  792E D758 99B9 A724 937A"
# environment settings
ENV NEXTCLOUD_PATH="/usr/share/webapps/nextcloud"

RUN echo "**** install build packages ****" \
 && apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	file \
	g++ \
	gcc \
	make \
	php7-dev \
	re2c \
	samba-dev \
	zlib-dev \
	gnupg \
 && echo "**** install runtime packages ****" \
 && apk add --no-cache \
	curl \
	ffmpeg \
	libxml2 \
	php7-apcu \
	php7-bz2 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-ftp \
	php7-gd \
	php7-gmp \
	php7-iconv \
	php7-imap \
	php7-intl \
	php7-ldap \
	php7-mbstring \
	php7-mcrypt \
	php7-memcached \
	php7-opcache \
	php7-pcntl \
	php7-pdo_mysql \
	php7-pdo_pgsql \
	php7-pdo_sqlite \
	php7-pgsql \
	php7-posix \
	php7-redis \
	php7-sqlite3 \
	php7-xml \
	php7-xmlreader \
	php7-zip \
	samba \
	sudo \
	tar \
	unzip \
	mariadb-client \
 && echo "**** compile smbclient ****" \
 && git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient \
 && cd /tmp/smbclient \
 && phpize7 \
 && ./configure --with-php-config=/usr/bin/php-config7 \
 && make \
 && make install \
 && echo "**** configure php and nginx for nextcloud ****" \
 && echo "extension="smbclient.so"" > /etc/php7/conf.d/00_smbclient.ini \
 && sed -i \
	-e 's/;opcache.enable.*=.*/opcache.enable=1/g' \
	-e 's/;opcache.interned_strings_buffer.*=.*/opcache.interned_strings_buffer=8/g' \
	-e 's/;opcache.max_accelerated_files.*=.*/opcache.max_accelerated_files=10000/g' \
	-e 's/;opcache.memory_consumption.*=.*/opcache.memory_consumption=128/g' \
	-e 's/;opcache.save_comments.*=.*/opcache.save_comments=1/g' \
	-e 's/;opcache.revalidate_freq.*=.*/opcache.revalidate_freq=1/g' \
	-e 's/;always_populate_raw_post_data.*=.*/always_populate_raw_post_data=-1/g' \
		/etc/php7/php.ini \
 && sed -i \
	'/opcache.enable=1/a opcache.enable_cli=1' \
		/etc/php7/php.ini \
 && echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php7/php-fpm.conf

WORKDIR /usr/share/webapps
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2 nextcloud-${VERSION}.tar.bz2
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2.sha256 nextcloud-${VERSION}.tar.bz2.sha256
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.tar.bz2.asc nextcloud-${VERSION}.tar.bz2.asc
ADD https://nextcloud.com/nextcloud.asc nextcloud.asc
RUN echo "Verifying integrity and authenticity..." \
 && CHECKSUM_STATE=$(echo -n $(sha256sum -c nextcloud-${VERSION}.tar.bz2.sha256) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "[!!] Checksum does not match!" && exit 1; fi \
 && gpg --import nextcloud.asc \
 && FINGERPRINT="$(LANG=C gpg --verify nextcloud-${VERSION}.tar.bz2.asc nextcloud-${VERSION}.tar.bz2 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking..." \
 && tar xfvj nextcloud-${VERSION}.tar.bz2 \
 && rm nextcloud-${VERSION}.tar.bz2* nextcloud.asc \
 && printf "chmod Files and Directories\n" \ 
 && find ${NEXTCLOUD_PATH}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${NEXTCLOUD_PATH}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R abc:abc ${NEXTCLOUD_PATH}

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && apk del --purge build-dependencies \
 && /tmp/cleanup.sh

# copy local files
COPY root/ /
