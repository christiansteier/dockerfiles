FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add \
	mariadb-client

RUN echo -e "#!/bin/sh \n\nif [ ! -d "/backup/daily" ]; then mkdir -p /backup/daily ;fi\ncd /backup/daily && /usr/local/sbin/db_backup\n" > /etc/periodic/daily/db_backup \
 && chmod +x /etc/periodic/daily/db_backup \
 && echo -e "#!/bin/sh \n\nif [ ! -d "/backup/weekly" ]; then mkdir -p /backup/weekly ;fi\ncd /backup/weekly && /usr/local/sbin/db_backup\n" > /etc/periodic/weekly/db_backup \
 && chmod +x /etc/periodic/weekly/db_backup \
 && echo -e "#!/bin/sh \n\nif [ ! -d "/backup/monthly" ]; then mkdir -p /backup/monthly ;fi\ncd /backup/monthly && /usr/local/sbin/db_backup\n" > /etc/periodic/monthly/db_backup \
 && chmod +x /etc/periodic/monthly/db_backup

COPY rootfs /

RUN s6-rmrf \
    /etc/s6/services/s6-fdholderd/down \
    /var/cache/apk/* \
    /usr/share/doc \
    /usr/share/man/ \
    /usr/share/info/* \
    /var/cache/man/* \
    /var/tmp
