FROM lsiobase/alpine.ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U add prosody ca-certificates curl \
 && sed -i "s*daemonize \= true*run_as_root = true\ndaemonize \= false*g" /etc/prosody/prosody.cfg.lua \
 && sed -i "s*\"posix\"*-- \"posix\"*g" /etc/prosody/prosody.cfg.lua

# Cleanup and security fixes
RUN curl -o /tmp/cleanup.sh -L https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/24cee1d4bdd713a447a500d39b3632e5d17fe6e7/docker-alpine-cleanup.sh \
 && chmod +x /tmp/cleanup.sh \
 && apk del curl \
 && /tmp/cleanup.sh

# add local files
COPY root/ /
EXPOSE 80 443 5222 5269 5347 5280 5281
