FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U add ca-certificates nginx \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2M;" > /etc/nginx/conf.d/uploads.conf
RUN rm /etc/nginx/conf.d/default.conf

# Cleanup and security fixes
COPY scripts/cleanup.sh /tmp/cleanup.sh
RUN /tmp/cleanup.sh

COPY rootfs /
EXPOSE 80/tcp 443/tcp
