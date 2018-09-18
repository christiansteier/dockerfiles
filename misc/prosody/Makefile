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
 ARCHTAG=arm64
endif

NAME=prosody
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g;s*alpine.x86_64*alpine*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 5222:5222 \
	-p 5269:5269 \
	-p 5280:5280 \
	-p 5281:5281 \
	-p 127.0.0.1:5347:5347 \
	-v /srv/docker/${NAME}:/config/prosody \
	${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}.${ARCHTAG}
