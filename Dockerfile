FROM ustwo/nodejs:4.2
MAINTAINER Arnau Siches <arnau@ustwo.com>

RUN apk add --update \
      make \
      python-dev \
 && rm -rf /var/cache/apk/* \
 && npm -g install browser-sync

ENTRYPOINT ["browser-sync"]
