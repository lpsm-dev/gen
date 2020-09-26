BINDIR      := $(CURDIR)/bin
BINNAME     ?= gen

COMMIT   := $(shell git rev-parse --short HEAD)
BUILT_AT := $(shell date +%FT%T%z)
BUILT_ON := $(shell hostname)

LDFLAGS := -w -s
LDFLAGS += -X main.commit=${COMMIT}
LDFLAGS += -X main.builtAt=${BUILT_AT}
LDFLAGS += -X main.builtBy=${USER}
LDFLAGS += -X main.builtOn=${BUILT_ON}

# Docker/Docker-Compose shortcuts.
ifeq ($(OS), Windows_NT)
	DOCKER_CONTAINER_LIST = $(shell docker ps -aq)
else
	DOCKER_CONTAINER_LIST = $(shell docker ps -aq)
endif

# Docker shortcuts
.PHONY: ds
ds:
	$(if $(strip $(DOCKER_CONTAINER_LIST)), docker stop $(DOCKER_CONTAINER_LIST))

.PHONY: dv
dv:
	$(if $(strip $(DOCKER_CONTAINER_LIST)), docker rm $(DOCKER_CONTAINER_LIST))

.PHONY: dvp
dvp:
	@-docker volume prune -f

.PHONY: dnp
dnp:
	@-docker network prune -f

.PHONY: dsp
dsp:
	@-docker system prune -af

.PHONY: clean
clean: ds dv dvp dnp
	@echo "# --------------------------------------"
	@echo "# Clean cleaning of docker environment"
	@echo "# --------------------------------------"

.PHONY: remove 
remove: ds dv dvp dnp dsp
	@echo "# --------------------------------------"
	@echo "# Deep cleaning of docker environment"
	@echo "# --------------------------------------"

# Docker Compose shortcuts
.PHONY: dcub
dcub:
	docker-compose up --build

.PHONY: dcubd
dcubd:
	docker-compose up --build -d

.PHONY: dcs
dcs:
	docker-compose down

.PHONY: dcps
dcps:
	docker-compose ps

.PHONY: run
run: dcps dcs dcub
ifneq ("$(wildcard $(./.env))","")
    dcps dcs dcubd
endif

.PHONY: rund
run: dcps dcs dcubd
ifneq ("$(wildcard $(./.env))","")
    dcps dcs dcubd
endif

# GoLang shortcuts.
.PHONY: all
all: gbuild

.PHONY: gbuild
gbuild: 
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags '$(LDFLAGS)' -o $(BINDIR)/$(BINNAME) main.go

.PHONY: gclean
gclean:
	go clean
	rm -f ./bin/*

.PHONY: glint
glint: gbuild
	golint -set_exit_status ./...

all: gbuild
