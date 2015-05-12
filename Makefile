.PHONY : help server rm reload

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
		--name browser-sync \
		ustwo/browser-sync \
		start --config bs-config.js
		# start --server --files="*.css"

rm :
	docker rm -f browser-sync

reload :
	docker exec -t \
		browser-sync \
		browser-sync reload
