FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U add ssmtp shadow mailx

COPY rootfs /
# Cleanup
RUN rm -rf \
	/var/cache/apk/* \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \ 
	/var/cache/man/* \ \
	/etc/s6/services/s6-fdholderd/down
