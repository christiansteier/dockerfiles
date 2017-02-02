FROM maxder/alpine-mini:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV ALPINE_RELEASE v3.5
ENV S6OVERLAY_RELEASE v1.18.1.5

RUN echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/main/" > /etc/apk/repositories    \
 && echo "http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/community/" >> /etc/apk/repositories \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk -U --no-progress add bash skalibs execline s6 s6-portable-utils gnupg

# Install s6-overlay
RUN apk add curl \
 && curl -sL https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY_RELEASE}/s6-overlay-nobin.tar.gz | tar xz

COPY rootfs /

# GNU libc (aka glibc) and set C.UTF-8 locale as default (based on frol/docker-alpine-glibc)
ARG ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download"
ARG ALPINE_GLIBC_PACKAGE_VERSION="2.23-r3"
ARG ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk"
ARG ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk"
ARG ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk"
RUN apk add --no-cache --virtual=.build-dependencies wget ca-certificates  \
 && wget "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" -O "/etc/apk/keys/sgerrand.rsa.pub" \
 && wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
 && apk add --no-cache \
    "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
    "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" \
 && rm "/etc/apk/keys/sgerrand.rsa.pub"  \
 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
 && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh  \
 && apk del glibc-i18n  \
 && rm "/root/.wget-hsts"  \
 && apk del .build-dependencies  \
 && rm "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
       "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
       "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"
ENV LANG=C.UTF-8

# set_tz from https://github.com/nimmis/docker-utils
RUN apk add curl \
 && curl -o /usr/sbin/set_tz -L https://raw.githubusercontent.com/nimmis/docker-utils/master/alpine/bin/set_tz \
 && chmod +x /usr/sbin/set_tz \
 && apk del curl

# Bash/Prompt customization
RUN echo 'PS1="\[\033[40;1;37m\][`date -R +%H:%M:%S`]\[\033[0m\] [\[\033[1;31m\]\u\[\033[0m\]@\h]:\[\033[01;34m\]\w\[\033[00m\]\$  "' >> /root/.bashrc

# Cleanup
RUN for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody); do deluser "$user"; done \
 && for group in $(cat /etc/group | awk -F':' '{print $1}' | grep -ve root -ve nobody); do delgroup "$group"; done \
 && rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

ENTRYPOINT ["/init"]
CMD []
