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

NAME=botpress
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-v /srv/docker/${NAME}/bot:/bot \
	-e BOTNAME=your_bot \
	-p 3000:3000 \
        ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
