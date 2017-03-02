FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U add ca-certificates nginx \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2M;" > /etc/nginx/conf.d/uploads.conf
RUN rm /etc/nginx/conf.d/default.conf

# Cleanup
RUN rm -rf \
	/var/cache/apk/* \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \ 
	/var/cache/man/* \ \
	/tmp \
	/var/tmp \
	/etc/s6/services/s6-fdholderd/down

COPY rootfs /
EXPOSE 80/tcp 443/tcp
