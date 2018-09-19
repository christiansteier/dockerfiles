FROM lsiobase/alpine.ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add mariadb-client curl

RUN echo -e "#!/bin/sh \n\nif [ ! -d "/backup/daily" ]; then mkdir -p /backup/daily ;fi\ncd /backup/daily && /defaults/auto-db-backup\n" > /etc/periodic/daily/auto-db-backup \
 && chmod +x /etc/periodic/daily/auto-db-backup \
 && echo -e "#!/bin/sh \n\nif [ ! -d "/backup/weekly" ]; then mkdir -p /backup/weekly ;fi\ncd /backup/weekly && /defaults/auto-db-backup\n" > /etc/periodic/weekly/auto-db-backup \
 && chmod +x /etc/periodic/weekly/auto-db-backup \
 && echo -e "#!/bin/sh \n\nif [ ! -d "/backup/monthly" ]; then mkdir -p /backup/monthly ;fi\ncd /backup/monthly && /defaults/auto-db-backup\n" > /etc/periodic/monthly/auto-db-backup \
&& chmod +x /etc/periodic/monthly/auto-db-backup

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && apk del curl \
 && /tmp/cleanup.sh

# copy local files
COPY root/ /
