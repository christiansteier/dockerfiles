FROM maxder/alpine-nginx-php7:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ENV VERSION 17.04
ENV RELEASE 2

RUN apk -U --no-progress add \
    mariadb-client

WORKDIR /usr/share/webapps
ADD https://launchpad.net/mahara/${VERSION}/${VERSION}.${RELEASE}/+download/mahara-${VERSION}.${RELEASE}.tar.gz app.tar.gz
RUN export APPDIR=/usr/share/webapps/mahara \
 && tar xf app.tar.gz \
 && mv mahara-*/htdocs mahara \
 && rm -rf mahara-* app.tar.gz \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R nginx:www-data ${APPDIR}

RUN export APPDIR=/usr/share/webapps/mahara \
 && echo -e "#!/bin/sh \n\n s6-setuidgid nginx php ${APPDIR}/lib/cron.php\n\nexit 0" > /etc/periodic/15min/mahara \
 && chmod +x /etc/periodic/15min/mahara

COPY rootfs/ /
RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*
