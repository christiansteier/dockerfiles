FROM maxder/alpine-mini:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ARG ALPINE=RELEASE
ARG S6OVERLAY=1.21.4.0
ARG GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161"
ARG BUILDWITHGLIBC=no

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE}/main/" > /etc/apk/repositories    \
 && echo "http://dl-cdn.alpinelinux.org/alpine/v${ALPINE}/community/" >> /etc/apk/repositories \
 && echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
 && apk -U upgrade \
 && apk add bash skalibs execline s6 s6-portable-utils gnupg curl

# Install s6-overlay
RUN curl -LO https://github.com/just-containers/s6-overlay/releases/download/v${S6OVERLAY}/s6-overlay-nobin.tar.gz \
 && curl -LO https://github.com/just-containers/s6-overlay/releases/download/v${S6OVERLAY}/s6-overlay-nobin.tar.gz.sig \
 && curl https://keybase.io/justcontainers/key.asc | gpg --import \
 && FINGERPRINT="$(LANG=C gpg --verify s6-overlay-nobin.tar.gz.sig s6-overlay-nobin.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && gpg --verify s6-overlay-nobin.tar.gz.sig s6-overlay-nobin.tar.gz \
 && if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi \
 && echo "All seems good, now unpacking..." \
 && tar -xf s6-overlay-nobin.tar.gz \
 && s6-rmrf s6-overlay-nobin*

COPY rootfs /

# GNU libc (aka glibc) (based on frol/docker-alpine-glibc)
RUN if [ $BUILDWITHGLIBC = "yes" ]; then export GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
 && export GLIBC_PACKAGE_VERSION="2.25-r0" \
 && curl -o /etc/apk/keys/sgerrand.rsa.pub -L https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub \
 && curl -LO ${GLIBC_BASE_URL}/${GLIBC_PACKAGE_VERSION}/glibc-${GLIBC_PACKAGE_VERSION}.apk \
 && curl -LO ${GLIBC_BASE_URL}/${GLIBC_PACKAGE_VERSION}/glibc-bin-${GLIBC_PACKAGE_VERSION}.apk \
 && curl -LO ${GLIBC_BASE_URL}/${GLIBC_PACKAGE_VERSION}/glibc-i18n-${GLIBC_PACKAGE_VERSION}.apk \
 && apk add glibc-${GLIBC_PACKAGE_VERSION}.apk glibc-bin-${GLIBC_PACKAGE_VERSION}.apk glibc-i18n-${GLIBC_PACKAGE_VERSION}.apk \
 && rm /etc/apk/keys/sgerrand.rsa.pub \
 && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
 && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh  \
 && apk del glibc-i18n  \
 && rm glibc-${GLIBC_PACKAGE_VERSION}.apk glibc-bin-${GLIBC_PACKAGE_VERSION}.apk glibc-i18n-${GLIBC_PACKAGE_VERSION}.apk; fi

# set_tz from https://github.com/nimmis/docker-utils
RUN curl -o /usr/sbin/set_tz -L https://raw.githubusercontent.com/nimmis/docker-utils/master/alpine/bin/set_tz \
 && chmod +x /usr/sbin/set_tz

# Bash/Prompt customization
RUN echo 'PS1="\[\033[42;37m\]- DOCKER -\[\033[40;1;37m\][`date -R +%H:%M:%S`]\[\033[0m\] [\[\033[1;31m\]\u\[\033[0m\]@\h]:\[\033[01;34m\]\w\[\033[00m\]\$  "' >> /root/.bashrc

# Cleanup and security fixes
COPY scripts/cleanup.sh /tmp/cleanup.sh
RUN /tmp/cleanup.sh

ENTRYPOINT ["/init"]
CMD []
