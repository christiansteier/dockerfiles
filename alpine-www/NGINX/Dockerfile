FROM maxder/alpine-base:x86_64
MAINTAINER Christian-Maxilian Steier

RUN apk -U add ca-certificates nginx openssl \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2M;" > /etc/nginx/conf.d/uploads.conf
RUN rm /etc/nginx/conf.d/default.conf

RUN openssl genrsa -out /etc/nginx/nginx.pem 4096 \
 && openssl req -new -x509 -days 3650 -key /etc/nginx/nginx.pem -out /etc/nginx/nginx.crt -subj "/C=US/CN=0.0.0.0" \
 && echo "" >> /etc/nginx/nginx.pem \
 && cat /etc/nginx/nginx.crt >> /etc/nginx/nginx.pem \
 && echo "" >> /etc/nginx/nginx.pem \
 && s6-envuidgid nginx s6-chown -U -- /etc/nginx/nginx.pem \
 && s6-envuidgid nginx s6-chown -U -- /etc/nginx/nginx.crt \
 && apk del openssl

# Cleanup
RUN rm -rf \
	/var/cache/apk/* \
	/usr/share/doc \
	/usr/share/man/ \
	/usr/share/info/* \ 
	/var/cache/man/* \ \
	/tmp \
	/etc/s6/services/s6-fdholderd/down

COPY rootfs /
EXPOSE 80/tcp 443/tcp
