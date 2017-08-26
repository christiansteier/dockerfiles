FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add \
	bitcoin \ 
	bitcoin-cli

COPY rootfs /
RUN s6-rmrf \
    /etc/s6/services/s6-fdholderd/down \
    /var/cache/apk/* \
    /usr/share/doc \
    /usr/share/man/ \
    /usr/share/info/* \
    /var/cache/man/* \
    /var/tmp
