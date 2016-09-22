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

NAME=limesurvey
NAMESPACE=maxder
IMAGENAME=alpine

all: build

build:
	$(MAKE) -C ../../alpine-www/NGINX php7build
	sed -i "s*ARCHTAG*${ARCHTAG}*g" Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-e APPADMIN=limeadmin \
	-e APPADMINPASS=pwd123 \
	-e APPADMINNAME=Admin \
	-e APPADMINEMAIL=admin@mydomain.org \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove:
	docker rm -f ${NAME} 

push:
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
