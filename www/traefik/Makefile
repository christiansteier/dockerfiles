.PHONY: all build run push

UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=.x86_64
endif
ifeq ($(UNAME), armv6l)
 ARCHTAG=.armhf
endif
ifeq ($(UNAME), armv7l)
 ARCHTAG=.armhf
endif
ifeq ($(UNAME), aarch64)
 ARCHTAG=.arm64
endif

NAME=traefik
NAMESPACE=cms0

all: build

build:
	sed -i "s*FROM lsiobase/alpine*FROM lsiobase/alpine${ARCHTAG}*g;s*FROM lsiobase/alpine.x86_64*FROM lsiobase/alpine*g" Dockerfile
	sed -i "s*ARCH=.x86_64*ARCH=${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME}${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 -p 8080:8080 \
	-v /srv/docker/${NAME}:/config/traefik \
	-v /var/run/docker.sock:/var/run/docker.sock \
	${NAMESPACE}/${NAME}${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME}
