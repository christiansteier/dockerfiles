#!/bin/bash
set -eu
source /scripts/buildconfig

echo -e "\n[i] Install s6-overlay\n"
GPG="DB30 1BA3 F6F8 07E0 D0E6  CCB8 6101 B278 3B2F D161"
S6OVERLAY=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
$minimal_apt_get_install curl gnupg
if [ $(uname -m) == "armv6l" ] || [ $(uname -m) == "armv7l" ]; then ARCHTAG=armhf ; elif [ $(uname -m) == "aarch64" ]; then ARCHTAG=aarch64 ; elif [ $(uname -m) == "x86_64" ]; then ARCHTAG=amd64 ; fi
curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz
curl -o /tmp/s6-overlay.tar.gz.sig -L https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY}/s6-overlay-${ARCHTAG}.tar.gz.sig
curl https://keybase.io/justcontainers/key.asc | gpg --import
FINGERPRINT="$(LANG=C gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz 2>&1 | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")"
gpg --verify /tmp/s6-overlay.tar.gz.sig /tmp/s6-overlay.tar.gz
if [ -z "${FINGERPRINT}" ]; then echo "[!!] Invalid GPG signature!" && exit 1; fi
if [ "${FINGERPRINT}" != "${GPG}" ]; then echo "[!!] Wrong GPG fingerprint!" && exit 1; fi
echo "[i] All seems good, now unpacking s6-overlay.tar.gz"
tar xzf /tmp/s6-overlay.tar.gz -C /

echo -e "\n[i] Install socklog-overlay\n"
SOCKLOG=$(curl -s https://api.github.com/repos/just-containers/socklog-overlay/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
curl -o /tmp/socklog-overlay-amd64.tar.gz -L https://github.com/just-containers/socklog-overlay/releases/download/${SOCKLOG}/socklog-overlay-${ARCHTAG}.tar.gz
tar xzf /tmp/socklog-overlay-amd64.tar.gz -C /

echo -e "\n[i] Install cron\n"
$minimal_apt_get_install cron

exit 0
