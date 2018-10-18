FROM lsiobase/alpine.nginx.ARCHTAG
MAINTAINER Christian-Maximilian Steier
ARG VERSION=18.10
ARG RELEASE=rc2

RUN echo "**** install runtime packages ****" \
 && apk add --no-cache \
 	ca-certificates \
 	gnupg \
	openssl \
	curl \
	libxml2 \
	imagemagick \
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
	php7-mysqli \
	php7-opcache \
	php7-pcntl \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-pgsql \
	php7-posix \
	php7-redis \
	php7-sqlite3 \
	php7-xml \
	php7-xmlreader \
	php7-xmlrpc \
	php7-zip \
	sudo \
	tar \
	unzip \
	mariadb-client \
 && echo "**** configure php and nginx ****" \
 && sed -i \
	-e 's/;opcache.enable.*=.*/opcache.enable=1/g' \
	-e 's/;opcache.interned_strings_buffer.*=.*/opcache.interned_strings_buffer=8/g' \
	-e 's/;opcache.max_accelerated_files.*=.*/opcache.max_accelerated_files=10000/g' \
	-e 's/;opcache.memory_consumption.*=.*/opcache.memory_consumption=128/g' \
	-e 's/;opcache.save_comments.*=.*/opcache.save_comments=1/g' \
	-e 's/;opcache.revalidate_freq.*=.*/opcache.revalidate_freq=1/g' \
	-e 's/;always_populate_raw_post_data.*=.*/always_populate_raw_post_data=-1/g' /etc/php7/php.ini \
 && sed -i '/opcache.enable=1/a opcache.enable_cli=1' /etc/php7/php.ini \
 && echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php7/php-fpm.conf \
 && echo "**** set default_bits in openssl to 2048 ****" \
 && sed -i "s*#default_bits*default_bits*g" /etc/ssl/openssl.cnf

WORKDIR /usr/share/webapps
ADD https://launchpad.net/mahara/${VERSION}/${VERSION}${RELEASE}/+download/mahara-${VERSION}${RELEASE}.tar.gz mahara-${VERSION}${RELEASE}.tar.gz
RUN export APPDIR="/usr/share/webapps/mahara" \
 && tar xf mahara-${VERSION}${RELEASE}.tar.gz \
 && mv mahara-*/htdocs mahara \
 && rm -rf mahara-* \
 && printf "chmod Files and Directories\n" \ 
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R abc:abc ${APPDIR}

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && /tmp/cleanup.sh

# copy local files
COPY root/ /
