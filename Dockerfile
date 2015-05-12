FROM node:0.12
MAINTAINER Arnau Siches <arnau@ustwo.com>

ENV TERM=xterm-256color

# TODO: optional dep failed, continuing fsevents@0.3.6
RUN npm -g install browser-sync

ENTRYPOINT ["browser-sync"]
