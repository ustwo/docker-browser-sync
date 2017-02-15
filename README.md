# Docker image for browser-sync

This Docker image wraps [BrowserSync](http://www.browsersync.io/) exposing its
command-line interface as the `ENTRYPOINT`.  This means you can use this image
as drop-in replacement for Browser Sync's CLI.

**Note**: please note this document assumes you're using Docker 1.9 or above.

It has been tested with Docker for Mac and with Docker Machine on OSX.


## Table of Contents

* [How to use this image](#how-to-use-this-image).
* [Docker Machine in OSX](#docker-machine-in-osx).


## How to use this image

The basic Browser Sync examples translated are the exact same commands with
the docker command prefixing it.

### Static sites

The following case publishes port 3000 and port 3001 so you can use the
static server and configure Browser Sync as always.

```sh
docker run -dt \
           --name browser-sync \
           -p 3000:3000 \
           -p 3001:3001 \
           -v $(PWD):/source \
           -w /source \
           ustwo/browser-sync \
           start --server --files "css/*.css"
```

### Dynamic sites

In this case, you have to let Docker know how to resolve the host you are
proxying to.  There are a couple of ways to do this so we'll go one by one.

#### Link

A docker link is a one-way connection between two containers.  Order matters
so you have to **first** start your app and then link Browser Sync to it:

```sh
docker run -dt --name myapp -p 8000:8000 myimage

docker run -dt \
           --name browser-sync \
           --link myapp \
           -p 3000:3000 \
           -p 3001:3001 \
           ustwo/browser-sync \
           start --proxy "myapp:8000" --files "css/*.css"
```

Notice the name of the app and the link are the same, and the browser sync
proxy flag has the same name as well as the exposed port of your app.  There
is no need to use the `-p 8000:8000` flag, it is just to make it more clear.


#### Custom network

A docker network is a connection between multiple containers.  Unlike links,
order does not matter so it is a more robust solution, but it requires setting
up the network before running the containers.  It is a one-time thing though:

```sh
docker network create bs
```

Then you start both services as follows:

```sh
docker run -dt --name myapp --net bs myimage

docker run -dt \
           --name browser-sync \
           --net bs \
           -p 3000:3000 \
           -p 3001:3001 \
           ustwo/browser-sync \
           start --proxy "myapp:8000" --files "css/*.css"
```


### Config file

Given the image exposes Browser Sync's CLI as is, you can use a config file
as well.

```sh
docker run -dt \
           --name browser-sync \
           --net bs \
           -p 3000:3000 \
           -p 3001:3001 \
           ustwo/browser-sync \
           -v $(PWD)/config.js:/source/config.js \
           start --config config.js
```


## Docker Machine in OSX

Docker Machine with Virtualbox has limited support of filesystem events.
[BrowserSync](http://www.browsersync.io/) uses filesystem events as its main
strategy to watch for changes and falls back to polling otherwise.  If you are
in this situation you can only use the polling strategy as shown in `sandbox/polling.js`.


## Contact

* open.source@ustwo.com


## Maintainers

* Arnau Siches (@arnau)

## License

There is no guarantee of active maintenance. Licensed under MIT.
