name := browser-sync
image_name := ustwo/$(name)
FLAGS = -v $(PWD)/sandbox:/sandbox \
        -w /sandbox


DOCKER := docker
DOCKER_TASK := $(DOCKER) run --rm -it
DOCKER_PROC := $(DOCKER) run -d -it

.PHONY: app \
        app-build \
        build \
        fsevents \
        help \
        polling \
        proxy \
        reload \
        rm


default: build

build:
	@$(DOCKER) build -t $(image_name) .

rm:
	@$(docker) rm -vf $(name)

shell:
	@$(call task,--entrypoint=sh,)

test-proxy:
	@$(call proc,start --config proxy.js)

test-polling:
	@$(call proc,start --config polling.js)

fsevents:
	@$(call proc,start --config fsevents.js)

reload:
	@$(DOCKER) exec -t \
    $(name) \
    $(name) reload

help:
	@$(call task,,--help)


###############################################################################
# Helpers                                                                     #
###############################################################################
app_name := testapp
APP_PORT = 8000

app-build:
	$(DOCKER) build -t $(app_name) -f Dockerfile.$(app_name) .

app:
	$(DOCKER_PROC) \
    -p $(APP_PORT):8000 \
    $(FLAGS) \
    --name $(app_name) \
    $(app_name)

define task
  $(DOCKER_TASK) \
    $(FLAGS) \
    $1 \
    $(image_name) \
    $2
endef

define proc
  $(DOCKER_PROC) \
    $(FLAGS) \
    -p 3000:3000 \
    -p 3001:3001 \
    $(image_name) \
    $1
endef
