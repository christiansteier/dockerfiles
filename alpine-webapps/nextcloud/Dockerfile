FROM maxder/alpine-nginx-php7:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ARG VERSION=11.0
ARG RELEASE=1
ARG GPG="2880 6A87 8AE4 23A2 8372  792E D758 99B9 A724 937A"

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

RUN sed -i "s*client_max_body_size 2M*client_max_body_size 2G*g" /etc/nginx/conf.d/uploads.conf \
 && sed -i "s*upload_max_filesize = 2M*upload_max_filesize = 2G*g" /etc/php/php.ini \
 && sed -i "s*post_max_size = 8M*post_max_size = 2G*g" /etc/php/php.ini \
 && echo -e "env[HOSTNAME] = \$HOSTNAME\nenv[PATH] = /usr/local/bin:/usr/bin:/bin\nenv[TMP] = /tmp\nenv[TMPDIR] = /tmp\nenv[TEMP] = /tmp" >> /etc/php/php-fpm.d/www.conf

WORKDIR /usr/share/webapps
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.${RELEASE}.tar.bz2 nextcloud-${VERSION}.${RELEASE}.tar.bz2
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.${RELEASE}.tar.bz2.sha256 nextcloud-${VERSION}.${RELEASE}.tar.bz2.sha256
ADD https://download.nextcloud.com/server/releases/nextcloud-${VERSION}.${RELEASE}.tar.bz2.asc nextcloud-${VERSION}.${RELEASE}.tar.bz2.asc
ADD https://nextcloud.com/nextcloud.asc nextcloud.asc
RUN export APPDIR=/usr/share/webapps/nextcloud \
 && echo "Verifying integrity and authenticity..." \
 && CHECKSUM_STATE=$(echo -n $(sha256sum -c nextcloud-${VERSION}.${RELEASE}.tar.bz2.sha256) | tail -c 2) \
 && if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "[!!] Checksum does not match!" && exit 1; fi \
 && gpg --import nextcloud.asc \
 && FINGERPRINT="$(LANG=C gpg --verify nextcloud-${VERSION}.${RELEASE}.tar.bz2.asc nextcloud-${VERSION}.${RELEASE}.tar.bz2 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking..." \
 && tar xfvj nextcloud-${VERSION}.${RELEASE}.tar.bz2 \
 && rm nextcloud-${VERSION}.${RELEASE}.tar.bz2* \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root:www-data ${APPDIR}/ \
 && chown -R nginx:www-data ${APPDIR}/apps/ \
 && chown -R nginx:www-data ${APPDIR}/config/ \
 && chown -R nginx:www-data ${APPDIR}/themes/ \
 && chown root:www-data ${APPDIR}/.htaccess \
 && chmod 0644 ${APPDIR}/.htaccess
RUN echo -e "#!/bin/sh \n\n s6-setuidgid nginx php /usr/share/webapps/nextcloud/cron.php\n # If music app exists, scan all files\n if [ -d "/usr/share/webapps/nextcloud/apps/music" ]; then s6-setuidgid nginx php /usr/share/webapps/nextcloud/occ music:scan --all ;fi\n" > /etc/periodic/15min/nextcloud \
 && chmod +x /etc/periodic/15min/nextcloud \
 && echo -e "#!/bin/sh \n\n s6-setuidgid nginx php /usr/share/webapps/nextcloud/occ files:scan --all\n" > /etc/periodic/daily/nextcloud \
 && chmod +x /etc/periodic/daily/nextcloud

COPY rootfs/ /
RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*
