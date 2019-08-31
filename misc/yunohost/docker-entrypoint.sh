#!/usr/bin/env bash
set -eu

TAG="#HACKED"
POSTINSTALL=${POSTINSTALL:-no}
WANIP4=$(dig @resolver1.opendns.com A myip.opendns.com +short -4)
DUMMYNIC=${DUMMYNIC:-no}
SMTPRELAY=${SMTPRELAY:-no}
SENDFROMDIFFERENTSENDER=${SENDFROMDIFFERENTSENDER:-no}

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

if [ $SENDFROMDIFFERENTSENDER = "yes" ]; then
  sed -i "s*reject_sender_login_mismatch*#reject_sender_login_mismatch*g" /etc/postfix/main.cf
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

# Additional scripts
if [ -d "$EXTRA" ]; then
  for file in $EXTRA/*; do
      [ -f "$file" ] && [ -x "$file" ] && "$file"
  done
fi

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

cat <<EOF > /etc/my.cnf
[client]
default-character-set 		= utf8mb4

[mysql]
default-character-set 		= utf8mb4
no-auto-rehash

[mysqld]
collation-server		= utf8mb4_unicode_ci
init-connect			= 'SET NAMES utf8mb4'
character-set-server		= utf8mb4
max_connections			= 100
connect_timeout			= 5
wait_timeout			= 600
max_allowed_packet		= 500M
thread_stack 			= 128
thread_cache_size		= 128
sort_buffer_size		= 4M
bulk_insert_buffer_size 	= 16M
tmp_table_size          	= 32M
max_heap_table_size     	= 32M
binlog_format           	= mixed
myisam_recover_options  	= BACKUP
key_buffer_size         	= 128M
#open-files-limit       	= 2000
table_open_cache        	= 400
myisam_sort_buffer_size 	= 512M
concurrent_insert       	= 2
sort_buffer_size 		= 64K
read_buffer_size        	= 2M
read_rnd_buffer_size    	= 1M
net_buffer_length 		= 2K
innodb_flush_method             = O_DIRECT
innodb_file_per_table           = 1
innodb_autoinc_lock_mode        = 2
innodb_lock_schedule_algorithm  = FCFS # MariaDB >10.1.19 and >10.2.3 only
innodb_log_file_size            = 32M
innodb_buffer_pool_size         = 256M
innodb_log_buffer_size          = 8M
innodb_open_files               = 400
innodb_io_capacity              = 400
innodb_large_prefix		= true
innodb_file_format		= Barracuda
query_cache_type                = 0  # for OFF
query_cache_limit               = 128K
query_cache_size                = 64M
tmp_table_size                  = 128M
max_heap_table_size             = 128M
server-id       		= 1
skip-external-locking

[mysqld_safe]
nice            		= 0

[myisamchk]
key_buffer_size 		= 8M
sort_buffer_size 		= 8M

[mysqldump]
quick
max_allowed_packet 		= 16M
EOF

if [ ! -d /var/run/fail2ban ]; then
 mkdir -p  /var/run/fail2ban
fi

if [ ! -d /run/sshd ]; then
 mkdir -p  /run/sshd
fi

if [ ! -d /run/php ]; then
 mkdir -p  /run/php
fi

exec "$@"
