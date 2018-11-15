FROM alpine
LABEL maintainer="Christian-Maximilian Steier"

RUN apk -U --no-cache --no-progress add \
        ca-certificates \
	curl \
	gnupg \
	grep \
	tar

# s6-overlay
RUN echo -e "\n[i] Install s6-overlay\n" \
 && GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161" \
 && S6OVERLAY=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
 && if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi \
 && curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz \
 && curl -o /tmp/s6-overlay.tar.gz.sig -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz.sig \
 && curl https://keybase.io/justcontainers/key.asc | gpg --import \
 && FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz \
 && if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi \
 && if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi \
 && echo -e "[i] All seems good, now unpacking s6-overlay.tar.gz \n" \
 && tar xzf /tmp/s6-overlay.tar.gz -C /

WORKDIR /config/traefik
RUN echo -e "\n[i] Install Treafik\n" \
 && export VERSION=$(curl -s https://api.github.com/repos/containous/traefik/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
 && export ARCH=$(uname -m) \
 && if [ ${ARCH} == armhf ]; then curl -o /traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm ; fi \
 && if [ ${ARCH} == arm64 ]; then curl -o /traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm64 ; fi \
 && if [ ${ARCH} == x86_64 ]; then curl -o /traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-amd64 ; fi \
 && if [ ${ARCH} == aarch64 ]; then curl -o /traefik -L https://github.com/containous/traefik/releases/download/${VERSION}/traefik_linux-arm64 ; fi \
 && chmod +x /traefik

# add local files
COPY root/ /

# Cleanup and security fixes
ADD https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/5317638ec64c0e8c3d22cd9965237a452bf82895/docker-alpine-cleanup.sh /tmp/cleanup.sh
RUN  apk del --purge curl grep gnupg tar \
 && chmod +x /tmp/cleanup.sh \
 && /tmp/cleanup.sh
ENTRYPOINT ["/init"]
