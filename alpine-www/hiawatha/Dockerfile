FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN echo -e "http://nl.alpinelinux.org/alpine/edge/testing\nhttp://nl.alpinelinux.org/alpine/edge/main\nhttp://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk-U add \
	ca-certificates \
	hiawatha \
	linux-pam \
	openssl \
	mbedtls \
	libxml2 \
	libxslt

RUN addgroup -Sg 82 www-data \
 && adduser -S -D -H -h /var/lib/hiawatha -s /sbin/nologin -G www-data -g www-data hiawatha \
 && sed -i "s*GENERAL SETTINGS*GENERAL SETTINGS\nLogFormat = extended\nServerString = SimpleHTTPserver\n*g;s*ServerId = nobody*ServerId = hiawatha*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*\#Binding*Binding \{\n       Port = 443\n       TLScertFile = tls/hiawatha.pem\n       MaxRequestSize = 2048 #2MB\n       TimeForRequest = 30\n\}\n\n\#Binding*g" /etc/hiawatha/hiawatha.conf \
 && apk del linux-pam

RUN openssl genrsa -out /etc/hiawatha/hiawatha.pem 4096 \
 && openssl req -new -x509 -days 3650 -key /etc/hiawatha/hiawatha.pem -out /tmp/hiawatha.crt -subj "/C=US/CN=0.0.0.0" \
 && echo "" >> /etc/hiawatha/hiawatha.pem \
 && cat /tmp/hiawatha.crt >> /etc/hiawatha/hiawatha.pem \
 && echo "" >> /etc/hiawatha/hiawatha.pem \
 && s6-envuidgid hiawatha s6-chown -U -- /etc/hiawatha/hiawatha.pem \
 && apk del openssl                

# Cleanup and security fixes
COPY scripts/cleanup.sh /tmp/cleanup.sh
RUN /tmp/cleanup.sh

COPY rootfs /
EXPOSE 80/tcp 443/tcp
