FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ARG ETHERPAD_VERSION=1.6.1

RUN apk -U add \
	g++ \
 	make \
 	nodejs \
 	python \
	curl \
	openssl \
	zlib \
	libuv \
	mariadb-client \
	pwgen \
	rsync

WORKDIR /usr/share/webapps
ADD https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz etherpad.tar.gz
RUN tar -xvzf etherpad.tar.gz \
 && cd etherpad-lite-${ETHERPAD_VERSION} \
 && rsync \
    --delete \
    --exclude 'CHANGELOG.md'\
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
 && apk del rsync

WORKDIR /usr/share/webapps/etherpad
RUN bin/installDeps.sh \
 && touch APIKEY.txt \
 && echo "$(pwgen -s -1 16)" > APIKEY.txt \
 && rm settings.json
 
 # Awesome Etherpad Plugins
RUN npm install ep_adminpads ep_headings2 ep_page_view ep_sociallinks ep_spellcheck ep_historicalsearch ep_horizontal_line ep_stop_writing ep_timesliderdiff ep_offline_edit ep_copy_paste_images ep_delete_empty_pads ep_email_notifications ep_markdownify ep_markdown

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

COPY rootfs/ /
EXPOSE 9001
