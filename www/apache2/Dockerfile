FROM httpd:alpine
LABEL maintainer="Christian-Maximilian Steier"

ARG WEB_USER=www-data
ARG WEB_GROUP=www-data
ARG APACHE_ROOT_DIR=/usr/local/apache2

# Load files directly from Github, so that an automatic build on Docker Hub is possible
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd-vhosts.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf
ADD https://raw.githubusercontent.com/christiansteier/dockerfiles/alpine/www/apache2/defaults/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN \
    # Cleanup based on https://gist.github.com/jumanjiman/f9d3db977846c163df12 \
    export sysdirs="/bin /etc /lib /sbin /usr" && \
    echo -e "[i] Remove crufty...\n   /etc/shadow-\n   /etc/passwd-\n   /etc/group-" && \
    find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} + && \
    echo "[i] Ensure system dirs are owned by root and not writable by anybody else." && \
    find $sysdirs -xdev -type d -exec chown root:root {} \; -exec chmod 0755 {} \; && \
    echo "[i] Set wright permissions for /tmp and /var/tmp." && \
    chmod a=rwx,o+t /tmp /var/tmp && \
    echo "[i] Remove all suid files." && \
    find $sysdirs -xdev -type f -a -perm +4000 -delete && \
    echo "[i] Remove other programs that could be dangerous." && \
    find $sysdirs -xdev \( -name hexdump -o -name chgrp -o -name od -o -name strings -o -name su \) -delete && \
    echo "[i] Remove unnecessary user accounts." && \
    for user in $(cat /etc/passwd | awk -F':' '{print $1}' | grep -ve root -ve nobody -ve daemon -ve www-data -ve nologin); do deluser "$user"; done && \
    for group in $(cat /etc/group | awk -F':' '{print $1}' | grep -ve root -ve nogroup -ve www-data -ve node -ve staff); do delgroup "$group"; done && \
    echo "[i] Remove interactive login shell" && \
    sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd && \
    echo "[i] Remove init scripts" && \
    rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf && \
    echo "[i] Remove kernel tunables" && \
    rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi && \
    echo "[i] Remove broken symlinks." && \
    find $sysdirs -xdev -type l -exec test ! -e {} \; -delete && \
    \
    apk --no-cache add shadow && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/httpd.conf && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf && \
    usermod -u 1000 ${WEB_USER} && \
    groupmod -g 1000 ${WEB_GROUP} && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR} && \
    apk del --purge shadow linux-pam && \
    rm -rf /var/cache/apk/* /etc/ssh/ssh_host_* /var/cache/ldconfig/aux-cache /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /tmp/* /etc/fstab \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["httpd-foreground"]
