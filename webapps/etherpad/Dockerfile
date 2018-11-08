FROM lsiobase/alpine
LABEL maintainer="Christian-Maximilian Steier"

RUN echo "**** install build packages ****" \
 && apk add --no-cache --virtual=build-dependencies \
 	g++ \
	make \
	rsync \
	grep \
 && echo "**** install runtime packages ****" \
 && apk -U --no-progress add \
        ca-certificates \
	curl \
	python \
	openssl \
	zlib \
	libuv \
	nodejs \
	mariadb-client

WORKDIR /usr/share/webapps
RUN export ETHERPAD_VERSION=$(curl -s https://api.github.com/repos/ether/etherpad-lite/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")') \
 && curl -L https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz -o etherpad.tar.gz \
 && tar -xvzf etherpad.tar.gz \
 && cd etherpad-lite-${ETHERPAD_VERSION} \
 && rsync \
	--delete \
	--exclude 'CHANGELOG.md' \
	--exclude 'CONTRIBUTING.md'\
	--exclude 'LICENSE'\
	--exclude 'README.md'\
	--exclude 'Makefile'\
	--exclude 'settings.json'\
	--exclude '.git'\
	--exclude '.gitignore'\
	--exclude '.travis.yml'\
	--exclude 'bin/buildDebian.sh'\
	--exclude 'bin/buildForWindows.sh'\
	--exclude 'bin/deb-src'\
	--exclude 'bin/installOnWindows.bat'\
	--exclude 'doc/'\
	--exclude 'start.bat'\
	--exclude 'tests/'\
	-a . /usr/share/webapps/etherpad \
 && rm -rf etherpad-lite-${ETHERPAD_VERSION} etherpad.tar.gz

WORKDIR /usr/share/webapps/etherpad
RUN bin/installDeps.sh \
 && rm settings.json

RUN echo "**** install awesome plugins ****" \
 && npm install \
 	ep_adminpads \
	ep_headings2 \
	ep_page_view \
	ep_sociallinks \
	ep_spellcheck \
	ep_historicalsearch \
	ep_horizontal_line \
	ep_stop_writing \
	ep_timesliderdiff \
	ep_offline_edit \
	ep_delete_empty_pads \
	ep_markdownify \
	ep_markdown

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && apk del --purge build-dependencies \
 && /tmp/cleanup.sh

# copy local files
COPY root/ /
