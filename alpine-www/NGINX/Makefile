.PHONY: all build phpbuild php7build run phprun php7run remove phpremove php7remove push phppush php7push

UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=x86_64
endif
ifeq ($(UNAME), armv6l)
 ARCHTAG=armhf
endif
ifeq ($(UNAME), armv7l)
 ARCHTAG=armhf
endif
ifeq ($(UNAME), aarch64)
 ARCHTAG=aarch64
endif

NAME=nginx
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

phpbuild:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	sed -i "s*alpine-base*alpine-php5-fpm*g" Dockerfile
	sed -i "s*=7*=5*g" ../php-fpm/Makefile
	$(MAKE) -C ../php-fpm build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG} .

php7build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	sed -i "s*alpine-base*alpine-php7-fpm*g" Dockerfile
	sed -i "s*=5*=7*g" ../php-fpm/Makefile
	$(MAKE) -C ../php-fpm build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}/sites-enabled:/etc/nginx/sites-enabled \
	-v /srv/docker/${NAME}/www:/usr/share/webapps \
	-v /srv/docker/${NAME}/log:/var/log/NGINX \
	-e TLS=yes \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
	docker exec ${NAME} /usr/sbin/set_tz Europe/Berlin

phprun:
	docker run -d --hostname ${NAME} --name ${NAME}-php \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}-php/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}-php/sites-enabled:/etc/nginx/sites-enabled \
	-v /srv/docker/${NAME}-php/www:/usr/share/webapps \
	-v /srv/docker/${NAME}-php/log:/var/log/NGINX \
	${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG}

php7run:
	docker run -d --hostname ${NAME} --name ${NAME}-php7 \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}-php7/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}-php7/sites-enabled:/etc/nginx/sites-enabled \
	-v /srv/docker/${NAME}-php7/www:/usr/share/webapps \
	-v /srv/docker/${NAME}-php7/log:/var/log/NGINX \
	${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG}

remove: 
	docker rm -f ${NAME}

phpremove:
	docker rm -f ${NAME}-php

php7remove:
	docker rm -f ${NAME}-php7

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phppush:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}-php:${ARCHTAG}

php7push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG}
