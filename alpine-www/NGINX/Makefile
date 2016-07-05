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

NAME=nginx
NAMESPACE=maxder
IMAGENAME=alpine

all: build
	
build:
	sed -i "s*alpine-base:ARCHTAG*alpine-base:${ARCHTAG}*g" Dockerfile_NGINX
	mv Dockerfile_NGINX Dockerfile
	docker build --rm --no-cache=true -t ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG} .
	mv Dockerfile Dockerfile_NGINX

run:
	docker run -d --hostname ${NAME} --name ${NAME} \
	-p 80:80 -p 443:443 \
	-v /srv/docker/${NAME}/tls:/etc/nginx/tls \
	-v /srv/docker/${NAME}/sites-enabled:/etc/nginx/sites-enabled \
	${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}

remove: 
	docker rm -f ${NAME}

push:	
	docker push ${NAMESPACE}/${IMAGENAME}-${NAME}:${ARCHTAG}
