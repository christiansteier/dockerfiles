.PHONY: all build run push

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

NAME=httpd
NAMESPACE=cms0

all: build

build:
	sed -i "s*FROM http*FROM ${ARCHTAG}/http*g;s*FROM /http*FROM http*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 \
	${NAMESPACE}/${NAME}

quickstart: build run

remove:
	docker rm -f ${NAME}
