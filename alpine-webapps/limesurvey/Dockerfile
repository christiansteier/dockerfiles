FROM maxder/alpine-nginx-php7:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ARG VERSION="3.7.2"
ARG RELEASE="180508"

RUN apk -U --no-progress add \
    mariadb-client

WORKDIR /usr/share/webapps
ADD https://download.limesurvey.org/latest-stable-release/limesurvey${VERSION}+${RELEASE}.tar.gz limesurvey${VERSION}+${RELEASE}.tar.gz
RUN export APPDIR=/usr/share/webapps/limesurvey \
 && tar xf limesurvey${VERSION}+${RELEASE}.tar.gz \
 && rm limesurvey${VERSION}+${RELEASE}.tar.gz \
 && find ${APPDIR}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${APPDIR}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R nginx:www-data ${APPDIR}/

COPY rootfs/ /
RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/*
