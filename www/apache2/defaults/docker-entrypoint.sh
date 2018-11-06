#!/bin/sh
set -e
SERVERNAME=${SERVERNAME:-localhost}

if [ ! -d /usr/local/apache2/sites ]; then
  mkdir -p /usr/local/apache2/sites
  chown www-data:root /usr/local/apache2/sites
fi

if ls /usr/local/apache2/sites/* > /dev/null 2>&1
then
  echo "[i] Site(s) for webserver found."
else
  echo "[i] Create example site in /usr/local/apache2/sites."
  cp /usr/local/apache2/conf/extra/httpd-vhosts.conf /usr/local/apache2/sites/httpd-vhosts.conf 
  chown www-data:www-data /usr/local/apache2/sites/httpd-vhosts.conf
fi

# Set server name.
sed -i "s*SERVERNAME*${SERVERNAME}*g" /usr/local/apache2/sites/httpd-vhosts.conf
echo "[i] Configured server name to ${SERVERNAME}."

exec "$@"
