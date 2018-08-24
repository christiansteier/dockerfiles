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

NAME=redis
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.x86_64*alpine*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 6379:6379 \
	-v /srv/docker/${NAME}:/config/redis \
	${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}

