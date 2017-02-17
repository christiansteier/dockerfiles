FROM maxder/alpine-mini:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ARG ALPINE=v3.5
ARG S6OVERLAY=v1.19.1.1
ARG GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE}/main/" > /etc/apk/repositories    \
 && echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE}/community/" >> /etc/apk/repositories \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk -U --no-progress add bash skalibs execline s6 s6-portable-utils gnupg curl

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-nobin.tar.gz s6-overlay-nobin.tar.gz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-nobin.tar.gz.sig s6-overlay-nobin.tar.gz.sig
RUN curl https://keybase.io/justcontainers/key.asc | gpg --import \
 && FINGERPRINT="$(LANG=C gpg --verify s6-overlay-nobin.tar.gz.sig s6-overlay-nobin.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && gpg --verify s6-overlay-nobin.tar.gz.sig s6-overlay-nobin.tar.gz \
 && if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking..." \
 && tar -xf s6-overlay-nobin.tar.gz \
 && s6-rmrf s6-overlay-nobin*

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
