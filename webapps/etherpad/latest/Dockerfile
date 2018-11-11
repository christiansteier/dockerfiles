FROM node:10-alpine
LABEL maintainer="Christian-Maximilian Steier"

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

ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/webapps/etherpad/v1.7/scripts/s6-overlay.sh /tmp/s6-overlay.sh
RUN chmod +x /tmp/s6-overlay.sh && \
    /tmp/s6-overlay.sh

WORKDIR /opt
RUN export ETHERPAD_VERSION=$(curl -s https://api.github.com/repos/ether/etherpad-lite/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') && \
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
    rm -rf etherpad-lite-${ETHERPAD_VERSION} etherpad.tar.gz

WORKDIR /opt/etherpad
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/webapps/etherpad/v1.7/scripts/ep_modules.sh /tmp/ep_modules.sh
RUN chmod +x /tmp/ep_modules.sh && \
    /tmp/ep_modules.sh && \
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

ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/webapps/etherpad/v1.7/root/etc/cont-init.d/10-config /etc/cont-init.d/10-config
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/webapps/etherpad/v1.7/root/etc/cont-init.d/20-install /etc/cont-init.d/20-install
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/webapps/etherpad/v1.7/root/etc/services.d/etherpad/run /etc/services.d/etherpad/run
RUN chmod +x /etc/cont-init.d/* && \
    chmod +x /etc/services.d/etherpad/run
ENTRYPOINT ["/init"]
