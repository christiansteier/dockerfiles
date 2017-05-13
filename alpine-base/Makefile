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
	cd ./gliderlabs-docker-alpine* && docker run --rm ${NAMESPACE}/${IMAGENAME}-builder:${ARCHTAG} -s -t UTC > versions/library-edge/rootfs.tar.xz
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}:${ARCHTAG} ./gliderlabs-docker-alpine*/versions/library-edge

mini:
	echo "build alpine-mini based on gliderlabs/alpine"
	sed -i "s*ARCHTAG*${ARCHTAG}*g" ./Dockerfile
	cd ./gliderlabs-docker-alpine* && docker run --rm ${NAMESPACE}/${IMAGENAME}-builder:${ARCHTAG} -s -c -t UTC > versions/gliderlabs-edge/rootfs.tar.xz
	cd ./gliderlabs-docker-alpine* && docker  build --rm -t ${NAMESPACE}/${IMAGENAME}-mini:${ARCHTAG} versions/gliderlabs-edge

buildwithglibc: 
	sed -i "s*BUILDWITHGLIBC=no*BUILDWITHGLIBC=yes*g" ./Dockerfile
	make build
	sed -i "s*BUILDWITHGLIBC=yes*BUILDWITHGLIBC=no*g" ./Dockerfile

build:  scratch builder library mini
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG} .
	make clean_build

clean_build:
	rm -r ./gliderlabs-docker-alpine*
	docker rmi -f maxder/alpine-scratch:${ARCHTAG}
	docker rmi -f maxder/alpine-builder:${ARCHTAG}
	docker rmi -f maxder/alpine-mini:${ARCHTAG}
	docker rmi -f maxder/alpine:${ARCHTAG}

push:
	docker push ${NAMESPACE}/${IMAGENAME}-base:${ARCHTAG}
