FROM maxder/alpine-mini:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV ALPINE_RELEASE v3.4
ENV S6OVERLAY_RELEASE v1.18.1.5

RUN echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/main/" > /etc/apk/repositories    \
 && echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/community/" >> /etc/apk/repositories \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk -U --no-progress add bash skalibs execline s6 s6-portable-utils

# Install s6-overlay
RUN apk add curl \
 && curl -sL https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY_RELEASE}/s6-overlay-nobin.tar.gz | tar xz

COPY rootfs /

# set_tz from https://github.com/nimmis/docker-utils
RUN apk add curl \
 && curl -o /usr/sbin/set_tz -L https://raw.githubusercontent.com/nimmis/docker-utils/master/alpine/bin/set_tz \
 && chmod +x /usr/sbin/set_tz \
 && apk del curl

# Bash/Prompt customization
RUN echo 'PS1="\[\033[40;1;37m\][`date -R +%H:%M:%S`]\[\033[0m\] [\[\033[1;31m\]\u\[\033[0m\]@\h]:\[\033[01;34m\]\w\[\033[00m\]\$  "' >> /root/.bashrc

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

ENTRYPOINT ["/init"]
CMD []
