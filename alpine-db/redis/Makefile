.PHONY: all build run remove push

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
ifeq ($(UNAME), aarch64)
 ARCHTAG=aarch64
endif

NAME=redis
NAMESPACE=maxder
IMAGENAME=alpine

all: deepbuild

build:  
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

deepbuild:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	
run:
	docker run -d --hostname ${NAME} --name ${NAME}-server \
	--privileged \
	-p 6379:6379 \
	-v /srv/docker/redis/db:/var/lib/redis \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove: 
	docker rm -f ${NAME}-server 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
