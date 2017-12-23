FROM maxder/alpine-nginx-php7:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ARG VERSION="2.73.0"
ARG RELEASE="171219"

RUN apk -U --no-progress add \
    mariadb-client

WORKDIR /usr/share/webapps
ADD https://github.com/LimeSurvey/LimeSurvey/archive/${VERSION}+${RELEASE}.tar.gz app.tar.gz
RUN export APPDIR=/usr/share/webapps/limesurvey \
 && tar xf app.tar.gz \
 && mv LimeSurvey-* limesurvey \
 && rm app.tar.gz \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R nginx:www-data ${APPDIR}/

COPY rootfs/ /
RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*
