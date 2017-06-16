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

NAME=ssmtp
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-e ROOTMAIL=username@gmail.com \
	-e ROOTNAME=Admin \
	-e MAILHUB=smtp.gmail.com:587 \
	-e REWRITEDOMAIN=gmail.com \
	-e HOSTDOMAIN=yourlocalhost.yourlocaldomain.tld \
	-e USETLS=Yes \
	-e USESTARTTLS=Yes \
	-e AUTHUSER=username \
	-e AUTHPASS=password \
	-e AUTHMETHOD=LOGIN \
	-e FROMLINEOVERRIDE=Yes \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove: 
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

