FROM node:8-alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG ETHERPAD_VERSION=1.7.5

RUN echo -e "\n[i] Install build packages \n" \
 && apk add --no-cache --virtual=build-dependencies \
        g++ \
        make \
        rsync \
        grep \
	gnupg \
	tar && \
    echo -e "[i] Install runtime packages \n" && \
    apk -U --no-cache --no-progress add \
	curl \
        python \
        libressl \
        zlib \
        libuv && \
    \
    # s6-overlay \
    echo -e "\n[i] Install s6-overlay\n" && \
    GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161" && \
    S6OVERLAY=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi && \
    curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz && \
    curl -o /tmp/s6-overlay.tar.gz.sig -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz.sig && \
    curl https://keybase.io/justcontainers/key.asc | gpg --import && \
    FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" && \
    gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz && \
    if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi && \
    if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi && \
    echo "[i] All seems good, now unpacking s6-overlay.tar.gz" && \
    tar xzf /tmp/s6-overlay.tar.gz -C / && \
    \
    # socklog-overlay \
    echo -e "\n[i] Install socklog-overlay\n" && \
    SOCKLOG=$(curl -s https://api.github.com/repos/just-containers/socklog-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
    if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi && \
    curl -o /tmp/socklog-overlay-${ARCHTAG}.tar.gz -L https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOG}/socklog-overlay-${ARCHTAG}.tar.gz && \
    tar xzf /tmp/socklog-overlay-${ARCHTAG}.tar.gz -C / && \
    \
    # Etherpad \
    cd /opt && \
    curl -L https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz -o etherpad.tar.gz && \
    tar -xvzf etherpad.tar.gz && \
    cd etherpad-lite-${ETHERPAD_VERSION} && \
    rsync \
	--delete \
	--exclude 'CHANGELOG.md' \
	--exclude 'CONTRIBUTING.md'\
	--exclude 'LICENSE'\
	--exclude 'README.md'\
	--exclude 'Makefile'\
	--exclude '.gitignore'\
	--exclude '.travis.yml'\
	--exclude 'bin/buildDebian.sh'\
	--exclude 'bin/buildForWindows.sh'\
	--exclude 'bin/deb-src'\
	--exclude 'bin/installOnWindows.bat'\
	--exclude 'doc/'\
	--exclude 'start.bat'\
	--exclude 'tests/'\
	-a . /opt/etherpad && \
    rm -rf etherpad-lite-${ETHERPAD_VERSION} etherpad.tar.gz && \
    cd /opt/etherpad && \
    echo -e "\n\n[i] Install awesome plugins \n" && \
    npm install \
	ep_adminpads \
	ep_font_color \
        ep_headings2 \
	ep_historicalsearch \
	ep_horizontal_line \
        ep_markdown \
	ep_markdownify \
	ep_offline_edit \
	ep_page_view \
	ep_spellcheck \
	ep_timesliderdiff && \
    bin/installDeps.sh && \
    cd src && \
    npm i --package-lock-only && \
    npm audit fix --force && \
    \
    # Cleanup \
    apk del --purge build-dependencies && \
    rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/* /etc/fstab

# copy local files
COPY root/ /

WORKDIR /opt/etherpad
ENTRYPOINT ["/init"]
