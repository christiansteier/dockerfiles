.PHONY: scratch build push

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

default: build
NAMESPACE=maxder
IMAGENAME=alpine
REL=v3.5

scratch:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./scripts/mkimage-alpine-scratch.sh
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./Dockerfile
	IMAGENAME=$(NAMESPACE)/$(IMAGENAME)-mini REL=$(REL) ./scripts/mkimage-alpine-scratch.sh

buildwithglibc: 
	sed -i "s*BUILDWITHGLIBC=no*BUILDWITHGLIBC=yes*g" ./Dockerfile
	make build
	sed -i "s*BUILDWITHGLIBC=yes*BUILDWITHGLIBC=no*g" ./Dockerfile

build:  scratch
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG} .
	docker rmi -f maxder/alpine-mini:${ARCHTAG}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG}
