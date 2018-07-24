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
 ARCHTAG=aarch64
endif

NAME=traefik
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 8080:8080 \
	-v /srv/docker/${NAME}/tls:/etc/traefik/tls \
	-v /srv/docker/${NAME}/config:/etc/traefik/config \
	-v /var/run/docker.sock:/var/run/docker.sock \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

