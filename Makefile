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
# Helpers                                                                     #
###############################################################################
app_name := testapp
APP_PORT = 8000

app-build:
	$(DOCKER) build -t $(app_name) -f Dockerfile.$(app_name) .
.PHONY: app-build

app:
	$(DOCKER_PROC) -p $(APP_PORT):8000 \
                 --name $(app_name) \
                 $(app_name)
.PHONY: app

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
