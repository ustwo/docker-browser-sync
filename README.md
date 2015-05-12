# Docker image for browser-sync

**THIS IMAGE IS NOT READY**

## Notes on watching files

As far as I understand browser-sync tries to rely on OS FS events to trigger a
reload.  The host events are not propagated to the guest (docker) FS as it is
a NFS (review this is true.)

A default case (tries to use FS events):

1. Spin up a server watching `*.css`;

    $ docker run --rm -t \
        -p 0.0.0.0:3000:3000 \
        -p 0.0.0.0:3001:3001 \
        -v $$(pwd)/sandbox:/sandbox \
        -w /sandbox \
        --name browser-sync \
        ustwo/browser-sync \
        start --server --files="*.css"

2. Open a browser: `open http://$(docker-machine ip):3000`
3. Change the CSS file in `sandbox/simple.css`;
4. Nothing happens.
5. Run `make reload`.
6. Eventually the browser changes the CSS.


Configured with `usePolling: true`:

1. Spin up a server watching `*.css`;

    $ docker run --rm -t \
        -p 0.0.0.0:3000:3000 \
        -p 0.0.0.0:3001:3001 \
        -v $$(pwd)/sandbox:/sandbox \
        -w /sandbox \
        --name browser-sync \
        ustwo/browser-sync \
        start --config bs-config.js

2. Open a browser: `open http://$(docker-machine ip):3000`
3. Change the CSS file in `sandbox/simple.css`;
4. Eventually the browser changes the CSS.



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

# 
