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

NAME=mariadb
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile  
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	
run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 127.0.0.1:3306:3306 \
	-e DBUSER="dbadmin" \
	-e DBPASS="12345" \
	-v /srv/docker/mysql:/var/lib/mysql \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

quickstart: build run

remove:
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
