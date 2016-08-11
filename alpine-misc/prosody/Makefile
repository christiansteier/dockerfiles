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

NAME=prosody
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	$(MAKE) -C ../../alpine-base build
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 5222:5222 \
	-p 5269:5269 \
	-p 5280:5280 \
	-p 5281:5281 \
	-p 127.0.0.1:5347:5347 \
	-v /srv/docker/${NAME}/config:/etc/prosody/config \
	-v /srv/docker/prosody/certs:/etc/prosody/certs \
	-v /srv/docker/prosody/logs:/var/log/prosody \
	-v /srv/docker/prosody/modules:/usr/lib/prosody-modules \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
