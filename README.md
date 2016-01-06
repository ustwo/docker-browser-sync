# Docker image for browser-sync

Docker has limited support of filesystem events.  [BrowserSync](http://www.browsersync.io/)
uses filesystem events as its main strategy to watch for changes and falls back
to polling otherwise.  My current understanding is that host filesystem events
are not propagated to the guest (Docker) filesystem given that it is a NFS.

This image has been tested only in MacOSX using VirtualBox.

This image is based on the great [Alpine Linux](http://alpinelinux.org/).


## Usage

The entrypoint of this image is the `browser-sync` CLI so you should use it in
a similar way you use `browser-sync`.

Simple watcher:

```sh
docker run --rm -t \
           -p 3000:3000 \
           -p 3001:3001 \
           -v $(PWD)/src:/source \
           -w /source \
           --name bs \
           ustwo/browser-sync \
           start --files "*.css"
```

Or create an alias to hide the noise:

```sh
alias browser-sync="docker run --rm -t \
                               -p 3000:3000 \
                               -p 3001:3001 \
                               -v $(PWD)/src:/source \
                               -w /source \
                               --name bs \
                               ustwo/browser-sync"
```

And then just do the normal browser-sync command:

```sh
browser-sync help
```


Proxy dockerised app:

```sh
docker run --rm -t \
           -p 3000:3000 \
           -p 3001:3001 \
           -v $(PWD)/src:/source \
           -w /source \
           --link myapp:myapp \
           --name bs \
           ustwo/browser-sync \
           start --files "*.css" \
                 --proxy "myapp:8888"
```

Docker links are limiting so meanwhile there is no better connectivity between
containers you can use the `docker0` interface:

```sh
docker run --rm -t \
           -p 3000:3000 \
           -p 3001:3001 \
           -v $(PWD)/src:/source \
           -w /source \
           --add-host dkr:172.17.42.1 \
           --name bs \
           ustwo/browser-sync \
           start --files "*.css" \
                 --proxy "dkr:8888"
```

You can use an external Browser Sync config file with something on the lines of:

```sh
docker run --rm -t \
           -p 3000:3000 \
           -p 3001:3001 \
           -v $(PWD)/src:/source \
           -w /source \
           --name bs \
           ustwo/browser-sync \
           start --config /source/config.js
```


## Maintainers

* [Arnau Siches](mailto:arnau@ustwo.com)
