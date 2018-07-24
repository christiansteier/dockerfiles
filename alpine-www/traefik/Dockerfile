FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV VERSION 1.7
ENV RELEASE 2
ENV ARCH ARCHTAG

RUN apk -U --no-progress add \
        ca-certificates \
	linux-pam

WORKDIR /etc/traefik
RUN mkdir -p config tls \
 && if [ ${ARCH} == armhf ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}.${RELEASE}/traefik_linux-arm ; fi \
 && if [ ${ARCH} == arm64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}.${RELEASE}/traefik_linux-arm64 ; fi \
 && if [ ${ARCH} == x86_64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}.${RELEASE}/traefik_linux-amd64 ; fi \
 && if [ ${ARCH} == aarch64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}.${RELEASE}/traefik_linux-arm64 ; fi \
 && chmod +x /usr/sbin/traefik \
 && addgroup -Sg 82 traefik \
 && adduser -S -D -H -h /etc/traefik -s /sbin/nologin -G traefik -g traefik traefik \
 && apk del curl linux-pam

# Cleanup
RUN rm -rf \
	/var/cache/apk/* \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \ 
	/var/cache/man/* \ \
	/tmp \
	/var/tmp \
	/etc/s6/services/s6-fdholderd/down

COPY rootfs /
