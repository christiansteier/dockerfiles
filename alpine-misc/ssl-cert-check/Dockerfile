FROM maxder/alpine-ssmtp:ARCHTAG
MAINTAINER Christian-Maxilian Steier

# Script from Matty: https://github.com/Matty9191/ssl-cert-check ##thx Matty
ADD https://raw.githubusercontent.com/Matty9191/ssl-cert-check/master/ssl-cert-check /usr/local/sbin/ssl-cert-check
RUN chmod +x /usr/local/sbin/ssl-cert-check \
 && mkdir -p /var/tmp

COPY rootfs /
RUN rm -rf /etc/s6/services/s6-fdholderd/down
