#!/bin/bash
set -e -x

[ $(id -u) -eq 0 ] || {
  printf >&2 '%s requires root\n' "$0"
  exit 1
}

usage() {
  printf >&2 '%s: [-r release] [-m mirror] [-s]\n' "$0"
  exit 1
}

tmp() {
  TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
  ROOTFS=$(mktemp -d /tmp/alpine-docker-rootfs-XXXXXXXXXX)
  trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
  set -x
  curl -s $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
    grep '^P:apk-tools-static$' -a -A1 | tail -n1 | cut -d: -f2
}

getapk() {
  curl -s $REPO/$ARCH/apk-tools-static-$(apkv).apk |
    tar -xz -C $TMP sbin/apk.static
}

mkbase() {
  $TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
    --root $ROOTFS --initdb add alpine-base
}

conf() {
  printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories
}

pack() {
  local id
  id=$(tar --numeric-owner -C $ROOTFS -c . | docker import - $DOCKER:$REL)
  docker tag $id $DOCKER:${ARCH}
  docker rmi -f $DOCKER:${REL}
}

:<<COM
while getopts "hr:m:s" opt; do
  case $opt in
    r)
      REL=$OPTARG
      ;;
    m)
      MIRROR=$OPTARG
      ;;
    s)
      SAVE=1
      ;;
    *)
      usage
      ;;
  esac
done
COM

DOCKER=${IMAGENAME:-alpine}
REL=${REL:-edge}
MIRROR=${MIRROR:-http://dl-cdn.alpinelinux.org/alpine}
REPO=$MIRROR/v$REL/main
ARCH=${ARCH:-ARCHTAG}

tmp && getapk && mkbase && conf && pack
