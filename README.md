# Docker image for browser-sync

**THIS IMAGE IS NOT READY**

## Notes on watching files

As far as I understand browser-sync tries to rely on OS FS events to trigger a
reload.  The host events are not propagated to the guest (docker) FS as it is
a NFS (review this is true.)

Important factor is that I'm running docker via docker-machine **inside**
virtualbox so it is an extra layer of indirection that can affect FS replication.

### Configured with `usePolling: false`

1. Spin up a server watching `*.css`;

        # make server
        $ docker run --rm -t \
            -p 0.0.0.0:3000:3000 \
            -p 0.0.0.0:3001:3001 \
            -v $$(pwd)/sandbox:/sandbox \
            -w /sandbox \
            --name browser-sync \
            ustwo/browser-sync \
            start --config fsevents.js

2. Open a browser: `open http://$(docker-machine ip):3000`
3. Change the CSS file in `sandbox/simple.css`;
4. Nothing happens.
5. Run `make reload`.
6. Eventually the browser changes the CSS.


### Configured with `usePolling: true`

1. Spin up a server watching `*.css`;

        # make polling
        $ docker run --rm -t \
            -p 0.0.0.0:3000:3000 \
            -p 0.0.0.0:3001:3001 \
            -v $$(pwd)/sandbox:/sandbox \
            -w /sandbox \
            --name browser-sync \
            ustwo/browser-sync \
            start --config polling.js

2. Open a browser: `open http://$(docker-machine ip):3000`
3. Change the CSS file in `sandbox/simple.css`;
4. Eventually the browser changes the CSS.


### Configured with `usePolling: false` and a proxy

1. Build the app;

        $ make build.app

2. Start the app;

        $ make app

3. Start browser-sync

        $ make proxy

4. Open a browser: `open http://$(docker-machine ip):3000`
5. Change the CSS file in `sandbox/simple.css`;
6. Nothing happens.
7. Run `make reload`.
8. Eventually the browser changes the CSS.


### Configured with `usePolling: false` and watching with an external watcher

(works with or without proxy)

1. Start browser-sync

        $ make server

2. Start the watcher (tested with fswatch)

        $ make watch

3. Change the CSS file in `sandbox/simple.css`;
4. Eventually the browser changes the CSS.



## Conclusions

Even though tests using the polling strategy feel a bit slow, it could be fast
enough for regular work.  Needs to be tested with a real project.

If that doesn't suit you, install browser-sync in your machine as always and
use it as a proxy against your Docker image.


## Quick start

The entrypoint of this image is `browser-sync` so you should use it in a similar way you use `browser-sync`.

    $ browser-sync start --proxy="192.168.99.100:8888" --files="*.css"

Would be equivalent to

    $ docker run --rm -t -p 0.0.0.0:3000:3000  -p 0.0.0.0:3001:3001 -v $(pwd):/data -w /data ustwo/browser-sync --proxy="localhost:8888" --files="*.css"


A more complex case would be proxying to a dockerised app:

    $ docker run -d --name myapp -p 8888:80 -v $(pwd):/home/myapp -w /home/myapp myapp
    $ docker run --rm -t -p 0.0.0.0:3000:3000  -p 0.0.0.0:3001:3001 --volumes-from myapp -w /home/myapp ustwo/browser-sync --proxy="192.168.99.100:8888" --files="*.css"


To access browser-sync hit your docker ip (using docker-machine
`docker-machine ip <env>`, using boot2docker `boot2docker ip`).
I.e `http://192.168.99.10:3000`


## Maintainers

* [Arnau Siches](mailto:arnau@ustwo.com)
