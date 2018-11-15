.PHONY: all build run quickstart remove

UNAME := $(shell uname -m)
ifeq ($(UNAME), x86_64)
 ARCHTAG=
 BUILDNAME=${NAME}
endif
ifeq ($(UNAME), armv6l)
 ARCHTAG=arm32v6
 BUILDNAME=${NAME}.${ARCHTAG}
endif
ifeq ($(UNAME), armv7l)
 ARCHTAG=arm32v7
 BUILDNAME=${NAME}.${ARCHTAG}
endif
ifeq ($(UNAME), aarch64)
 ARCHTAG=aarch64
 BUILDNAME=${NAME}.${ARCHTAG}
endif

NAME=traefik
NAMESPACE=cms0

all: build

build:
	sed -i "s*FROM alpine*FROM ${ARCHTAG}/alpine*g;s*FROM /alpine*FROM alpine*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${BUILDNAME} .

run:
	docker-compose up -d

quickstart: build run

remove:
	docker-compose down --volume
