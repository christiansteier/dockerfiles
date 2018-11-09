.PHONY: all build run remove

UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=
endif
ifeq ($(UNAME), armv6l)
 ARCHTAG=arm32v6
endif
ifeq ($(UNAME), armv7l)
 ARCHTAG=arm32v7
endif
ifeq ($(UNAME), aarch64)
 ARCHTAG=arm64v8
endif

NAME=limesurvey
NAMESPACE=cms0

all: build

build:
	sed -i "s*FROM php*FROM ${ARCHTAG}/php*g;s*FROM /php*FROM php*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 \
	${NAMESPACE}/${NAME}

quickstart: build run

remove:
	docker rm -f ${NAME}
