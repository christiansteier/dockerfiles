.PHONY: all build run push

UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=
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

NAME=etherpad
NAMESPACE=cms0

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME}${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 9001 \
	-v /srv/docker/${NAME}:/config \
	${NAMESPACE}/${NAME}${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${NAME}${ARCHTAG}
