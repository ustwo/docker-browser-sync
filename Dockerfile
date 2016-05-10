# FROM ustwo/nodejs:4.2
FROM node:6-slim
MAINTAINER Arnau Siches <arnau@ustwo.com>

RUN npm -g install browser-sync

WORKDIR /source

ENTRYPOINT ["browser-sync"]
