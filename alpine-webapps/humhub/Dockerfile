FROM maxder/alpine-hiawatha-php7:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ARG VERSION=1.2
ARG RELEASE=4

RUN apk -U --no-progress add \
    imagemagick \
    graphviz \
    ffmpeg \                                                                                                                                                                                                                                 
    mariadb-client

WORKDIR /usr/share/webapps
ADD https://github.com/humhub/humhub/archive/v${VERSION}.${RELEASE}.tar.gz app.tar.gz
RUN export APPDIR=/usr/share/webapps/humhub \
 && tar xf app.tar.gz \
 && mv humhub-* humhub \
 && rm app.tar.gz \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R hiawatha:www-data ${APPDIR}
WORKDIR /usr/share/webapps/humhub 
RUN composer global require "fxp/composer-asset-plugin:1.*" \
 && composer update

 ## Set cronjob
RUN export APPDIR=/usr/share/webapps/humhub \
 && echo -e "#!/bin/sh \n\n s6-setuidgid hiawatha php ${APPDIR}/protected/yii cron/hourly\n\nexit 0" > /etc/periodic/15min/humhub \
 && chmod +x /etc/periodic/15min/humhub \
 && echo -e "#!/bin/sh \n\n s6-setuidgid hiawatha php ${APPDIR}/protected/yii cron/daily\n\nexit 0" > /etc/periodic/daily/humhub \
 && chmod +x /etc/periodic/daily/humhub

COPY rootfs/ /
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*
