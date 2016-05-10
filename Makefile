name := browser-sync
image_name := ustwo/$(name)
FLAGS = -v $(PWD)/sandbox:/source \
        --name $(name)

DOCKER := docker
DOCKER_TASK := $(DOCKER) run --rm -it
DOCKER_PROC := $(DOCKER) run -d -it

build:
	@$(DOCKER) build -t $(image_name) .
.PHONY: build

push:
	@$(DOCKER) push $(image_name)
.PHONY: push

shell:
	@$(call task,--entrypoint=sh,)
.PHONY: shell


###############################################################################
# Test                                                                        #
###############################################################################
test-clean:
	$(DOCKER) rm -vf $(name) testapp
	$(DOCKER) network rm bs
.PHONY: clean

test-proxy: test-app
	$(call proc,start --proxy=testapp:8000 --files="*.css")
.PHONY: test-proxy

test-server:
	$(DOCKER_PROC) $(FLAGS) \
                 -p 3000:3000 \
                 -p 3001:3001 \
                 $(image_name) \
                 $1 start --server --files "*.css"
.PHONY: test-server


test-proxy-polling: test-app
	@$(call proc,start --config proxy_polling.js)
.PHONY: test-proxy-polling

test-proxy-fsevents: test-app
	@$(call proc,start --config proxy_fsevents.js)
.PHONY: test-proxy-fsevents

test-polling:
	@$(call proc,start --config polling.js)
.PHONY: test-polling

test-fsevents:
	@$(call proc,start --config fsevents.js)
.PHONY: test-fsevents


test-app:
	$(DOCKER) network create bs
	$(DOCKER_PROC) -p 8000:8000 \
                 --name testapp \
                 --net bs \
                 -v $(PWD)/sandbox:/sandbox \
                 -w /sandbox \
                 python:2 python -m SimpleHTTPServer
.PHONY: test-app

###############################################################################
# Helpers                                                                     #
###############################################################################

define task
  $(DOCKER_TASK) $(FLAGS) \
                 $1 \
                 $(image_name) \
                 $2
endef

define proc
  $(DOCKER_PROC) $(FLAGS) \
                 --net bs \
                 -p 3000:3000 \
                 -p 3001:3001 \
                 $(image_name) \
                 $1
endef
