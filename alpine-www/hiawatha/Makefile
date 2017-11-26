.PHONY: all build phpbuild run phprun remove phpremove push phppush

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

NAME=hiawatha
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

phpbuild:
	sed -i "s*alpine-base:ARCHTAG*alpine-php7-fpm:${ARCHTAG}*g" Dockerfile
	sed -i "s*=5*=7*g" ../php-fpm/Makefile
	$(MAKE) -C ../php-fpm build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/config:/etc/hiawatha/config \
	-v /srv/docker/${NAME}/tls:/etc/hiawatha/tls \
	-v /srv/docker/${NAME}/sites-enabled:/etc/hiawatha/sites-enabled \
	-v /srv/docker/${NAME}/www:/usr/share/webapps \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phprun:
	docker run -d --hostname ${NAME} --name ${NAME}-php \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}-php/tls:/etc/hiawatha/tls \
	-v /srv/docker/${NAME}-php/sites-enabled:/etc/hiawatha/sites-enabled \
	-v /srv/docker/${NAME}-php/www:/usr/share/webapps \
	${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG}

remove: 
	docker rm -f ${NAME}

phpremove:
	docker rm -f ${NAME}-php

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

phppush:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}-php7:${ARCHTAG}
