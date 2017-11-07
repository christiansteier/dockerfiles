FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U add prosody \
 && sed -i "s*daemonize \= true*daemonize \= false*g"  /etc/prosody/prosody.cfg.lua

RUN s6-rmrf \
    /etc/s6/services/s6-fdholderd/down \
    /etc/s6/services/cron \
    /var/cache/apk/* \
    /var/cache/man/* \
    /usr/share/* \
    /var/tmp \
&& touch /firstrun 

COPY rootfs /
EXPOSE 80 443 5222 5269 5347 5280 5281
ENV __FLUSH_LOG yes
