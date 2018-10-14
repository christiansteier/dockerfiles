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

NAME=traefik
TRAEFIKVERSION=1.7.2
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.x86_64*alpine*g;s*TRAEFIKVERSION*${TRAEFIKVERSION}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${TRAEFIKVERSION} .

buildlatest:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.x86_64*alpine*g;s*TRAEFIKVERSION*${TRAEFIKVERSION}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:latest .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 -p 8080:8080 \
	-v /srv/docker/${NAME}:/config/traefik \
	-v /var/run/docker.sock:/var/run/docker.sock \
	${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${TRAEFIKVERSION}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	buildlatest
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:${TRAEFIKVERSION}
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}:latest
