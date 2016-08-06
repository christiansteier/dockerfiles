#!/bin/bash
# Based on https://gist.github.com/jumanjiman/f9d3db977846c163df12

sysdirs="
  /bin
  /etc
  /lib
  /sbin
  /usr
"
# Remove apk configs.
#find $sysdirs -xdev -regex '.*apk.*' -exec rm -fr {} +

# Remove crufty...
#   /etc/shadow-
#   /etc/passwd-
#   /etc/group-
find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} +

# Ensure system dirs are owned by root and not writable by anybody else.
find $sysdirs -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;
  
# Remove all suid files.
find $sysdirs -xdev -type f -a -perm +4000 -delete

# Remove other programs that could be dangerous.
find $sysdirs -xdev \( \
  -name hexdump -o \
  -name chgrp -o \
  -name ln -o \
  -name od -o \
  -name strings -o \
  -name su \
  \) -delete
  
# Remove unnecessary user accounts.
sed -i -r '/^(nogroup|www-data|nginx|root)/!d' /etc/group
sed -i -r '/^(nobody|nginx|root)/!d' /etc/passwd

# Remove interactive login shell 
sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

rm -rf /etc/s6/services/s6-fdholderd/down /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp /etc/fstab

# Remove init scripts
rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf

# Remove kernel tunables
rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi

# Remove broken symlinks (because we removed the targets above).
find $sysdirs -xdev -type l -exec test ! -e {} \; -delete

exit 0
