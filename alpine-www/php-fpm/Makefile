.PHONY: all build php7build run php7run remove php7remove push php7push

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

VERSION:=7
NAME=php${VERSION}-fpm
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	mv Dockerfile_PHP${VERSION} Dockerfile
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" ./Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	mv Dockerfile Dockerfile_PHP${VERSION}

run:	
	docker run -d --hostname ${NAME} --name ${NAME} -p 9000  ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove: 
	docker rm -f ${NAME} 

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
