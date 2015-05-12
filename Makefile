.PHONY : help server

help :
	docker run --rm -t \
		-p 0.0.0.0:3000:3000 \
		-p 0.0.0.0:3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		ustwo/browser-sync \
		--help

server :
	docker run --rm -t \
		-p 0.0.0.0:3000:3000 \
		-p 0.0.0.0:3001:3001 \
		-v $$(pwd)/sandbox:/sandbox \
		-w /sandbox \
		ustwo/browser-sync \
		start --server --files="*.css"
