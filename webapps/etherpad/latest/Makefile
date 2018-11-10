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

NAME=etherpad-lite
NAMESPACE=cms0

all: build

build:
	sed -i "s*FROM node*FROM ${ARCHTAG}/node*g;s*FROM /node*FROM node*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${NAME} .

run:    
	docker-compose up -d

quickstart: build run

remove: 
	docker-compose rm -s
