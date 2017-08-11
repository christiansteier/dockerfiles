.PHONY: all build run push

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

NAME=transmission
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile  
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	
run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 9091:9091 -p 51413:51413 \
	-e USER=transmission -e PASSWORD=transmission \
	-v /srv/docker/transmission/downloads:/var/transmission/downloads \
	-v /srv/docker/transmission/incomplete:/var/transmission/incomplete \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
