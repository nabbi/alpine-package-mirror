#!/bin/sh

set -e

# make sure we never run 2 rsync at the same time
lockfile="/tmp/alpine-mirror.lock"
if [ -z "$flock" ]
then
  exec env flock=1 flock -n $lockfile $0 "$@"
fi

src=rsync://rsync.alpinelinux.org/alpine/
dest=/var/www/localhost/htdocs/alpine/

/usr/bin/rsync \
  --verbose \
  --perms \
  --recursive \
  --update \
  --append \
  --exclude-from /etc/rsync/exclude.txt \
  --delete \
  --timeout=120 \
  --delete-after \
  "$src" "$dest"
