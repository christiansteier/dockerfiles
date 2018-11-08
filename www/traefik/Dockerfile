FROM lsiobase/alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG ARCH=.x86_64
RUN apk -U --no-progress add \
        ca-certificates \
	curl \
	grep

VOLUME /config
WORKDIR /config/traefik
RUN mkdir -p config tls \
 && export VERSION=$(curl -s https://api.github.com/repos/containous/traefik/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
 && if [ ${ARCH} == .armhf ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm ; fi \
 && if [ ${ARCH} == .arm64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm64 ; fi \
 && if [ ${ARCH} == .x86_64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 ; fi \
 && if [ ${ARCH} == .aarch64 ]; then curl -o /usr/sbin/traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm64 ; fi \
 && chmod +x /usr/sbin/traefik

# add local files
COPY root/ /

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && /tmp/cleanup.sh \
 && apk del --purge curl grep

# ports and volumes
EXPOSE 80 443
