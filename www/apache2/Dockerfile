FROM httpd:alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG APACHE_ROOT_DIR=/usr/local/apache2

# Load files directly from Github, so that an automatic build on github is possible
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/httpd.conf \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
 
RUN apk --no-cache add shadow \
 && usermod -u 1000 ${WEB_USER} \
 && groupmod -g 1000 ${WEB_GROUP} \
 && chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}
