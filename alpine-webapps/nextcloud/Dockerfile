FROM maxder/alpine-hiawatha-php:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ENV VERSION 9.0
ENV RELEASE 53

RUN apk -U --no-progress add \
    file \
    libintl \
    perl-xml-simple \
    perl-xml-writer@testing \
    memcached \
    libmemcached \
    imagemagick \
    bzip2 \
    graphviz \
    ffmpeg \
    mariadb-client

RUN sed -i "s*MaxRequestSize = 2048 \#2MB*MaxRequestSize = 2097152 \#2GB*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*TimeForRequest = 30*TimeForRequest = 600*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*upload_max_filesize = 2M*upload_max_filesize = 2G*g" /etc/php/php.ini \
 && sed -i "s*post_max_size = 8M*post_max_size = 2G*g" /etc/php/php.ini

WORKDIR /usr/share/webapps
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.${RELEASE}.tar.bz2 app.tar.bz2
RUN export APPDIR=/usr/share/webapps/nextcloud \
 && tar xfvj app.tar.bz2 \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root:www-data ${APPDIR}/ \
 && chown -R hiawatha:www-data ${APPDIR}/apps/ \
 && chown -R hiawatha:www-data ${APPDIR}/config/ \
 && chown -R hiawatha:www-data ${APPDIR}/themes/ \
 && chown root:www-data ${APPDIR}/.htaccess \
 && chmod 0644 ${APPDIR}/.htaccess

RUN echo -e "#!/bin/sh \n\n s6-setuidgid hiawatha php /usr/share/webapps/nextcloud/cron.php\n # If music app exists, scan all files\n if [ -d "/usr/share/webapps/nextcloud/apps/music" ]; then s6-setuidgid hiawatha php /usr/share/webapps/nextcloud/occ music:scan --all ;fi\n" > /etc/periodic/15min/nextcloud \
 && chmod +x /etc/periodic/15min/nextcloud

COPY rootfs/ /
RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*
