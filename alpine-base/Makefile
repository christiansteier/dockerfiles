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
REL=3.7

scratch:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./scripts/mkimage-alpine-scratch.sh
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*RELEASE*${REL}*g" ./Dockerfile
	IMAGENAME=$(NAMESPACE)/$(IMAGENAME)-mini REL=${REL} ARCH=${ARCHTAG} ./scripts/mkimage-alpine-scratch.sh

buildwithglibc: 
	sed -i "s*BUILDWITHGLIBC=no*BUILDWITHGLIBC=yes*g" ./Dockerfile
	make build
	sed -i "s*BUILDWITHGLIBC=yes*BUILDWITHGLIBC=no*g" ./Dockerfile

build:  scratch
	docker build --no-cache --rm -t ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG} .
	docker rmi -f maxder/alpine-mini:${ARCHTAG}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG}
