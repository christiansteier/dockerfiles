FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add \
	mariadb \
	mariadb-client

COPY rootfs /

RUN rm -rf /etc/s6/services/cron /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 3306/tcp
VOLUME ["/var/lib/mysql"]
