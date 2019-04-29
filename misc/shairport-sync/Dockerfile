FROM lsiobase/alpine:arm32v7-3.9

RUN apk -U add --no-cache dbus && \
    apk add --no-cache \ 
	--repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
	--allow-untrusted \ 
	shairport-sync && \
    rm -rf \
	/etc/avahi/services/* \ 
	/var/cache/apk/* \
	/etc/ssh/ssh_host_* \ 
	/var/cache/ldconfig/aux-cache \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \ 
	/var/cache/man/* \
	/tmp/* \
	/etc/fstab
# copy local files
COPY root/ /
