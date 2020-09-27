GOPATH ?= $(shell go env GOPATH)

# Ensure GOPATH is set before running build process.
ifeq "$(GOPATH)" ""
  $(error Please set the environment variable GOPATH before running `make`)
endif

GOOS       := $(shell go env GOOS)
GOARCH     := $(shell go env GOARCH)

# NOTE: '-race' requires cgo; enable cgo by setting CGO_ENABLED=1
# BUILD_FLAG := -race
GOBUILD    := CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build $(BUILD_FLAG)

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
LDFLAGS += -X "github.com/lpmatos/gen/utils.ClientVersion=$(shell cat VERSION)"
LDFLAGS += -X "github.com/lpmatos/gen/utils.GoVersion=$(shell go version)"
LDFLAGS += -X "github.com/lpmatos/gen/utils.UTCBuildTime=$(shell date -u '+%Y-%m-%d %I:%M:%S')"
LDFLAGS += -X "github.com/lpmatos/gen/utils.GitBranch=$(shell git rev-parse --abbrev-ref HEAD)"
LDFLAGS += -X "github.com/lpmatos/gen/utils.GitTag=$(shell git describe --tags)"
LDFLAGS += -X "github.com/lpmatos/gen/utils.GitHash=$(shell git rev-parse HEAD)"

# GoLang shortcuts.
.PHONY: gbuild ginstall glint gdeps gclean

# Install all the build and lint dependencies
gsetup:
	@echo "==> Setup..."
	go mod download
	go generate -v ./...
	@echo ""

gbuild: 
	@echo "==> Building..."
	$(GOBUILD) -o $(BINDIR)/$(BINNAME) -ldflags '$(LDFLAGS)' main.go
	@echo ""

ginstall:
	@echo "==> Installing..."
	go install -x ${SRC}
	@echo ""

glint:
	@echo "==> Running lint..."
	golint -set_exit_status ./...

gdeps:
	@echo "===> Tidy Dependencies..."
	go mod tidy && go mod vendor
	@echo ""

build_linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(BUILD_FLAG) -o $(BINDIR)/$(BINNAME)_linux_amd64 -ldflags '$(LDFLAGS)' main.go

build_darwin:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build $(BUILD_FLAG) -o $(BINDIR)/$(BINNAME)_darwin_amd64 -ldflags '$(LDFLAGS)' main.go

pack: build_linux build_darwin
	@echo "==> Packing ..."
	@tar czvf $(BINNAME)-$(shell cat VERSION).linux-amd64.tar.gz $(BINDIR)/$(BINNAME)_linux_amd64 
	@echo ""
	@tar czvf $(BINNAME)-$(shell cat VERSION).darwin-amd64.tar.gz $(BINDIR)/$(BINNAME)_darwin_amd64
	@echo ""
	rm $(BINDIR)/$(BINNAME)_linux_amd64 
	rm $(BINDIR)/$(BINNAME)_darwin_amd64

misspell:
	@# misspell - Correct commonly misspelled English words in source files
	@#    go get -u github.com/client9/misspell/cmd/misspell
	@echo "==> Runnig misspell ..."
	find . -name '*.go' -not -path './vendor/*' -not -path './_repos/*' | xargs misspell -error
	@echo ""

gclean:
	@echo "==> Cleaning..."
	go clean -x -i ${SRC}
	rm -rf ./bin/*
	rm -rf ./vendor
	rm -rf *.tar.gz
	@echo ""

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
