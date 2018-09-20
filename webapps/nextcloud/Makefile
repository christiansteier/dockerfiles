.PHONY: all build run push

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
 ARCHTAG=arm64
endif

NAME=nextcloud
NEXTCLOUDVERSION=14.0.0
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.nginx.x86_64*alpine.nginx*g;s*NEXTCLOUDVERSION*${NEXTCLOUDVERSION}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${NEXTCLOUDVERSION} .

buildlatest:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.x86_64*alpine*g;s*TRAEFIKVERSION*${NEXTCLOUDVERSION}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:latest .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}:/config/nextcloud \
	${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${NEXTCLOUDVERSION}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	buildlatest
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${NEXTCLOUDVERSION}
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:latest
