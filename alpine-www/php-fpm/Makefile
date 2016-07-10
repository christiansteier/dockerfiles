.PHONY: all build php7build run php7run remove php7remove push php7push

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

NAME=php-fpm
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	mv Dockerfile_PHP5 Dockerfile
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" ./Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	mv Dockerfile Dockerfile_PHP5

php7build:
	mv Dockerfile_PHP7 Dockerfile
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" ./Dockerfile
	$(MAKE) -C ../../alpine-base build
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-php7-fpm:${ARCHTAG} .
	mv Dockerfile Dockerfile_PHP7

run:	
	docker run -d --hostname ${NAME} --name ${NAME} -p 9000  ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

php7run:
	docker run -d --hostname ${NAME} --name php7-fpm -p 9000  ${NAMESPACE}/${IMAGENAME}-$php7-fpm:${ARCHTAG}

remove: 
	docker rm -f ${NAME} 

php7remove:
	docker rm -f php7-fpm

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

php7push:
	docker push ${NAMESPACE}/${IMAGENAME}-php7-fpm:${ARCHTAG}
