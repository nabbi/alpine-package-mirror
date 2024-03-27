
FROM    alpine:latest

MAINTAINER Bodo Schulz <bodo@boone-schulz.de>

ENV \
  ALPINE_MIRROR="mirrors.gigenet.com" \
  ALPINE_VERSION="v3.19"

EXPOSE  80

# ---------------------------------------------------------------------------------------

RUN \
  echo "http://${ALPINE_MIRROR}/alpinelinux/${ALPINE_VERSION}/main"       > /etc/apk/repositories && \
  echo "http://${ALPINE_MIRROR}/alpinelinux/${ALPINE_VERSION}/community" >> /etc/apk/repositories && \
  apk --no-cache update && \
  apk --no-cache upgrade && \
  apk --quiet --no-cache add \
    lighttpd \
    rsync

COPY rootfs/ /

CMD     ["lighttpd", "-f", "/etc/lighttpd/lighttpd.conf", "-D"]

