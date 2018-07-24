.PHONY: all build run start remove clean push

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

NAME=mariadb
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile  
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	
run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 127.0.0.1:3306:3306 \
	-v /srv/docker/${NAME}:/var/lib/mysql \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

start:  build run

remove:
	docker rm -f ${NAME}

clean:  remove
	rm -r /srv/docker/${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
