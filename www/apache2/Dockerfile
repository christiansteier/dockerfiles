FROM debian:stable-slim
LABEL maintainer="Christian-Maximilian Steier"

# System
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/debian/scripts/buildconfig /scripts/buildconfig
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/debian/scripts/prepare.sh  /scripts/prepare.sh
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/debian/scripts/system_services.sh /scripts/system_services.sh
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/debian/scripts/utilities.sh /scripts/utilities.sh
ADD https://gist.githubusercontent.com/christiansteier/5553e32f2f289fefd40641758117b1fe/raw/74fdbdb4511744323db6470cdf596fdbf9fe1897/docker-debian-cleanup.sh /scripts/cleanup.sh
RUN chmod +x /scripts/* && \
    /scripts/prepare.sh && \
    /scripts/utilities.sh && \
    /scripts/system_services.sh

# Apache
RUN apt-get install -y --no-install-recommends apache2 apache2-utils openssl \
 && echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername \
 && a2dissite 000-default

# copy local files
COPY root/ /

RUN /scripts/cleanup.sh
ENTRYPOINT ["/init"]
