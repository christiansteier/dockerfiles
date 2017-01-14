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

NAME=jabbergram
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	$(MAKE) -C ../../alpine-base build
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-v /srv/docker/jabbergram/config:/etc/jabbergram \
	-e JID=exampleJid@nope.org \
	-e JIDPASS=difficultPassword \
	-e MUC=exampleMuc@muc.nope.org \
	-e NICK=jabbergram \
	-e TOKEN=jabbergramBotTokken \
	-e GROUP=-10293943920 \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
