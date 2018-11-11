FROM node:8-alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG ETHERPAD_VERSION=1.7.0

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
        libuv

ADD scripts/s6-overlay.sh /tmp/s6-overlay.sh
RUN chmod +x /tmp/s6-overlay.sh && \
    /tmp/s6-overlay.sh

WORKDIR /opt
RUN curl -L https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz -o etherpad.tar.gz && \
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
    rm -rf etherpad-lite-${ETHERPAD_VERSION} etherpad.tar.gz

WORKDIR /opt/etherpad
ADD scripts/ep_modules.sh /tmp/ep_modules.sh
RUN chmod +x /tmp/ep_modules.sh && \
    /tmp/ep_modules.sh && \
    rm /tmp/ep_modules.sh && \
    bin/installDeps.sh && \
    cd src && \
    npm i --package-lock-only && \
    npm audit fix --force

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/5317638ec64c0e8c3d22cd9965237a452bf82895/docker-alpine-cleanup.sh && \
    chmod +x /tmp/cleanup.sh && \
    apk del --purge build-dependencies && \
    /tmp/cleanup.sh && \
    rm -rf /tmp/*

# copy local files
COPY root/ /
ENTRYPOINT ["/init"]
