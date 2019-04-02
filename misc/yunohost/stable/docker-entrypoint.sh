#!/usr/bin/env bash
set -eu

TAG="#HACKED"
POSTINSTALL=${POSTINSTALL:-no}
DOMAIN=${DOMAIN:-yunohost.local}
PASSWORD=${PASSWORD:-}
WANIP4=$(dig @resolver1.opendns.com A myip.opendns.com +short -4)
DUMMYNIC=${DUMMYNIC:-no}

export LANG=de_DE.UTF-8
echo "export LANG=de_DE.UTF-8" >> ~/.bash_login

if [ ! -f /var/log/auth.log ]; then
  touch /var/log/auth.log
fi

if [ $DUMMYNIC = "yes" ]; then
  ip addr add $WANIP4/32 dev lo
fi

## hack /etc/hosts
cat <<EOF > /usr/local/bin/hostfiles-hack.sh
#!/bin/bash

TAG="#HACKED"

# hack /etc/hosts

grep -q "^$TAG" /etc/hosts
if [ "$1" != "0" ]
then
	cp /etc/hosts /etc/hosts_cp
	sed -i "1i$TAG" /etc/hosts_cp
	umount /etc/hosts
	cp /etc/hosts_cp /etc/hosts
fi

# hack /etc/hostname

cp /etc/hostname /etc/hostname_cp
umount /etc/hostname
cp /etc/hostname_cp /etc/hostname
EOF
chmod 744 /usr/local/bin/hostfiles-hack.sh

## hack /etc/hostname
cat <<EOF > /etc/systemd/system/hostfiles-hack.service
[Unit]
After=sshd.service

[Service]
ExecStart=/usr/local/bin/hostfiles-hack.sh

[Install]
WantedBy=default.target
EOF
chmod 664 /etc/systemd/system/hostfiles-hack.service
systemctl enable hostfiles-hack

if [ $POSTINSTALL = "yes" ]; then
cat <<EOF > /usr/local/bin/yunohost-postinstall.sh
#!/usr/bin/env bash

echo -e "\n[i] Perform now postinstallation for $DOMAIN!\n"

mkdir -p /run/php /var/run/fail2ban /run/sshd
systemctl restart sshd
systemctl restart slapd
systemctl restart fail2ban
systemctl restart php7.0-fpm

echo $DOMAIN > /etc/mailname
yunohost tools postinstall -d $DOMAIN -p $PASSWORD
echo -e "\n[i] Install a Let's Encrypt certificate\n"
yunohost domain cert-install
EOF
chmod 744 /usr/local/bin/yunohost-postinstall.sh
fi

exec "$@"
