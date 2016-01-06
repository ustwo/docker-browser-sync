name := browser-sync
image_name := ustwo/$(name)
FLAGS = -v $(PWD)/sandbox:/sandbox \
        -w /sandbox

DOCKER := docker
DOCKER_TASK := $(DOCKER) run --rm -it
DOCKER_PROC := $(DOCKER) run -d -it

build:
	@$(DOCKER) build -t $(image_name) .
.PHONY: build

clean:
	@$(DOCKER) rm -vf $(name)
.PHONY: clean

shell:
	@$(call task,--entrypoint=sh,)
.PHONY: shell

test-proxy:
	@$(call proc,start --config proxy.js)
.PHONY: test-proxy

test-polling:
	@$(call proc,start --config polling.js)
.PHONY: test-polling

test-fsevents:
	@$(call proc,start --config fsevents.js)
.PHONY: test-fsevents

reload:
	@$(DOCKER) exec -t $(name) reload
.PHONY: reload

help:
	@$(call task,,--help)
.PHONY: help


###############################################################################
# Test                                                                        #
###############################################################################
app-install:
	$(DOCKER_PROC) -p 8000:8000 \
                 --name testapp \
                 -v $(PWD)/sandbox:/sandbox \
                 -w /sandbox \
                 python:2 python -m SimpleHTTPServer
.PHONY: app-install

app-clean:
	$(DOCKER) rm -vf testapp
.PHONY: app-clean

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
                 -p 3000:3000 \
                 -p 3001:3001 \
                 $(image_name) \
                 $1
endef
