FROM httpd:alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG APACHE_ROOT_DIR=/usr/local/apache2

# Load files directly from Github, so that an automatic build on Docker Hub is possible
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/httpd.conf \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
 
RUN apk --no-cache add shadow \
 && usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}
 
 # Cleanup and security fixes
ADD https://gist.githubusercontent.com/christiansteier/dd8c5544c69504d29bd938726691255b/raw/656048e5890a7a43030f82be5a014efde418eb8f/docker-alpine-cleanup.sh /tmp/cleanup.sh
RUN chmod +x /tmp/cleanup.sh \
 && apk del --purge shadow linux-pam \
 && /tmp/cleanup.sh

ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["httpd-foreground"]
