FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier
	
RUN apk -U add redis \
 && sed -i 's/^\(bind .*\)$/# \1/' /etc/redis.conf \
 && sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis.conf \
 && sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis.conf \
 && if [ $(uname -m) == "armv6l" ]; then sed "s*# maxmemory <bytes>*maxmemory 67108864*g" -i /etc/redis.conf ; elif [ $(uname -m) == "armv7l" ]; then sed "s*# maxmemory <bytes>*maxmemory 67108864*g" -i /etc/redis.conf ; fi

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

COPY rootfs /
EXPOSE 6379/tcp
