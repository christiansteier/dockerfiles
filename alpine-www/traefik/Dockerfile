FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV VERSION 1.0.0
#ENV RELEASE 3
ENV ARCH ARCHTAG

RUN apk -U --no-progress add \
        ca-certificates \
        curl \
	linux-pam

WORKDIR /etc/traefik
RUN mkdir -p config tls \
 && if [ ${ARCH} == armhf ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}/traefik_linux-arm ; fi \
 && if [ ${ARCH} == x86_64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/v${VERSION}/traefik_linux-amd64 ; fi \
 && chmod +x /usr/sbin/traefik \
 && addgroup -Sg 82 traefik \
 && adduser -S -D -H -h /etc/traefik -s /sbin/nologin -G traefik -g traefik traefik \
 && apk del curl linux-pam

# Cleanup and security fixes
COPY scripts/cleanup.sh /tmp/cleanup.sh
RUN /tmp/cleanup.sh

COPY rootfs /
EXPOSE 80/tcp 8080/tcp
