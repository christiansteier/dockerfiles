FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ARG ALPINE=v3.7

RUN echo "https://dl-cdn.alpinelinux.org/alpine/${ALPINE}/main/" > /etc/apk/repositories    \
 && echo "https://dl-cdn.alpinelinux.org/alpine/${ALPINE}/community/" >> /etc/apk/repositories \
 && apk -U add \
	python \
        nodejs \
	nodejs-npm \
        openssl

RUN npm --unsafe-perm install -g botpress

COPY rootfs /
RUN rm -rf \
	/etc/s6/services/s6-fdholderd/down \
	/etc/s6/services/cron \
	/var/cache/apk/* \
	/usr/share \
	/var/cache/man/* \
	/var/tmp \
	/tmp/*
