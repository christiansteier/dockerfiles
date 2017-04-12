.PHONY: all build push

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

NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
scratch:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./scripts/mkimage-alpine-scratch.sh
	IMAGENAME=$(NAMESPACE)/$(IMAGENAME)-scratch REL=$(VERSION) ./scripts/mkimage-alpine-scratch.sh

builder:
	curl -Lo master.tar.gz https://codeload.github.com/gliderlabs/docker-alpine/legacy.tar.gz/master
	tar -xf master.tar.gz
	rm master.tar.gz
	echo "Set builder images to FROM ${IMAGENAME}-scratch"
	sed -i "/FROM/ s:.*:FROM $(NAMESPACE)/$(IMAGENAME)-scratch:" ./gliderlabs-docker-alpine*/builder/Dockerfile
	sed -i "s*$(NAMESPACE)/$(IMAGENAME)-scratch*$(NAMESPACE)/$(IMAGENAME)-scratch:${ARCHTAG}*g" ./gliderlabs-docker-alpine*/builder/Dockerfile
	docker build --rm -t $(NAMESPACE)/$(IMAGENAME)-builder:${ARCHTAG} ./gliderlabs-docker-alpine*/builder

library:
	echo "build library alpine"
	cd ./gliderlabs-docker-alpine* && docker run --name alpine-build-${ARCHTAG} ${NAMESPACE}/${IMAGENAME}-builder:${ARCHTAG} -s -t UTC -r edge -m http://nl.alpinelinux.org/alpine > versions/library-edge/rootfs.tar.gz
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}:${ARCHTAG} ./gliderlabs-docker-alpine*/versions/library-edge

mini:
	echo "build alpine-mini based on gliderlabs/alpine"
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./Dockerfile
	docker rm -f alpine-build-${ARCHTAG}
	cd ./gliderlabs-docker-alpine* && docker run --name alpine-build-${ARCHTAG} ${NAMESPACE}/${IMAGENAME}-builder:${ARCHTAG} -s -c -t UTC -r edge -m http://alpine.gliderlabs.com/alpine > versions/gliderlabs-edge/rootfs.tar.gz
	cd ./gliderlabs-docker-alpine* && docker  build --rm -t ${NAMESPACE}/${IMAGENAME}-mini:${ARCHTAG} versions/gliderlabs-edge

build:  scratch builder library mini
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG} .
	make clean_build

buildwithglibc:  scratch builder library mini
	sed -i "BUILDWITHGLIBC=no*BUILDWITHGLIBC=yes" ./Dockerfile
        docker build --rm -t ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG} .
        make clean_build

clean_build:
	rm -r ./gliderlabs-docker-alpine*
	docker rm -f alpine-build-${ARCHTAG}
	docker rmi -f maxder/alpine-scratch:${ARCHTAG}
	docker rmi -f maxder/alpine-builder:${ARCHTAG}
	docker rmi -f maxder/alpine-mini:${ARCHTAG}
	docker rmi -f maxder/alpine:${ARCHTAG}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG}
