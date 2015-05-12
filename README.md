**THIS IMAGE IS NOT READY FOR SERIOUS WORK**

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
