#!/usr/bin/env bash
set -eu

TAG="#HACKED"
POSTINSTALL=${POSTINSTALL:-no}
WANIP4=$(dig @resolver1.opendns.com A myip.opendns.com +short -4)
DUMMYNIC=${DUMMYNIC:-no}
SMTPRELAY=${SMTPRELAY:-no}

export LANG=de_DE.UTF-8
echo "export LANG=de_DE.UTF-8" >> ~/.bash_login

if [ ! -f /var/log/auth.log ]; then
  touch /var/log/auth.log
fi

if [ $DUMMYNIC = "yes" ]; then
  ip addr add $WANIP4/32 dev lo
fi

if [ ! -d /usr/share/man/man1 ]; then
  mkdir -p /usr/share/man/man1
fi

if [ ! -d /usr/share/man/man7 ]; then
  mkdir -p /usr/share/man/man7
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
cat <<EOF > /usr/local/bin/postinstall
#!/usr/bin/env bash

echo -e "\n[i] Perform now postinstallation for $DOMAIN!\n"

mkdir -p /run/php

if [ ! -d /var/run/fail2ban ]; then
 mkdir -p  /var/run/fail2ban
fi
systemctl is-active fail2ban || systemctl restart fail2ban
if [ ! -d /run/sshd ]; then
 mkdir -p  /run/sshd
fi
systemctl is-active sshd || systemctl restart sshd
systemctl is-active slapd || systemctl restart slapd
if [ ! -d /run/php ]; then
 mkdir -p  /run/php
fi
systemctl is-active php7.0-fpm || systemctl restart php7.0-fpm

echo $DOMAIN > /etc/mailname
yunohost tools postinstall -d $DOMAIN -p $PASSWORD
echo -e "\n[i] Install a Let's Encrypt certificate\n"
yunohost domain cert-install
systemctl stop postinstall
systemctl disable postinstall
EOF
chmod 744 /usr/local/bin/postinstall
cat <<EOF > /etc/systemd/system/postinstall.service
[Unit]
After=sshd.service

[Service]
ExecStart=/usr/local/bin/postinstall

[Install]
WantedBy=default.target
EOF
chmod 664 /etc/systemd/system/postinstall.service
systemctl enable postinstall
fi

if [ $SMTPRELAY = "yes" ]; then
cat <<EOF > /usr/local/bin/external_smtp
#!/usr/bin/env bash

echo -e "\n[i] Configure postfix to use $SMTPRELAYDOMAIN as external SMTP server!\n"

echo -e "\n\nsmtp_sasl_auth_enable = yes\nsmtp_sasl_security_options = noanonymous\nsmtp_sasl_password_maps = hash:/etc/postfix/saslpasswd\nsmtp_always_send_ehlo = yes\nrelayhost = $SMTPRELAYDOMAIN\n" >> /etc/postfix/main.cf
echo "$SMTPRELAYDOMAIN $SMTPRELAYLOGIN:$SMTPRELAYPASSWORD" > /etc/postfix/saslpasswd
postmap /etc/postfix/saslpasswd
systemctl restart postfix
systemctl stop external_smtp
systemctl disable external_smtp
EOF
chmod 744 /usr/local/bin/external_smtp
cat <<EOF > /etc/systemd/system/external_smtp.service
[Unit]
After=sshd.service

[Service]
ExecStart=/usr/local/bin/external_smtp

[Install]
WantedBy=default.target
EOF
chmod 664 /etc/systemd/system/external_smtp.service
systemctl enable external_smtp
fi

exec "$@"
