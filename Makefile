.PHONY : help server proxy polling rm reload build.app app

help :
	docker run --rm -t \
		-p 3000:3000 \
		-p 3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		ustwo/browser-sync \
		--help

server :
	docker run --rm -t \
		-p 3000:3000 \
		-p 3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		--name browser-sync \
		ustwo/browser-sync \
		start --config fsevents.js

build.app :
	docker build -t "testapp" -f Dockerfile.testapp .

app :
	docker run -d \
		-p 8000:8000 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		--name testapp \
		testapp

proxy :
	docker run --rm -t \
		-p 3000:3000 \
		-p 3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		--name browser-sync \
		ustwo/browser-sync \
		start --config proxy.js

polling :
	docker run --rm -t \
		-p 3000:3000 \
		-p 3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		--name browser-sync \
		ustwo/browser-sync \
		start --config polling.js

rm :
	docker rm -f browser-sync

reload :
	docker exec -t \
		browser-sync \
		browser-sync reload

watch :
	fswatch -or -l 0.2 $$(pwd)/sandbox \
		| xargs -n1 \
			docker exec -t \
				browser-sync \
				browser-sync reload


