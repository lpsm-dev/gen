SHELL := /bin/bash

include Makefile.variables

.PHONY: help
help:
	@echo 'Management commands for cicdtest:'
	@echo
	@echo 'Usage:'
	@echo '  ## Golang Commands'
	@echo '    make setup           	Install all the build and lint dependencies.'
	@echo '    make build         		Build Gen binary.'
	@echo '    make install         	Install Gen CLI.'
	@echo '    make lint              	Lint go Files.'
	@echo '    make misspell         	Running misspell command in Go files.'
	@echo '    make gclean       	  	Clean all golang files and packages generated in some build process.'
	@echo
	@echo '  ## Docker/Docker Compose Commands'
	@echo '    make setup           	Configures Minishfit/Docker directory mounts.'
	@echo

# GoLang shortcuts.
# Install all the build and lint dependencies.
.PHONY: setup
setup:
	@echo "==> Setup..."
	go mod download
	go generate -v ./...
	@echo ""

# Build Gen binary.
.PHONY: build
build: 
	@echo "==> Building..."
	$(GOBUILD) -o $(BINDIR)/$(BINNAME) -ldflags '$(LDFLAGS)' main.go
	@echo ""

# Install Gen CLI.
.PHONY: install
install:
	@echo "==> Installing..."
	go install -x ${SRC}
	@echo ""

# Lint Go files.
.PHONY: lint
lint:
	@echo "==> Running lint..."
	golint -set_exit_status ./...

# Running misspell command in Go files.
.PHONY: misspell
misspell:
	@# misspell - Correct commonly misspelled English words in source files
	@#    go get -u github.com/client9/misspell/cmd/misspell
	@echo "==> Runnig misspell ..."
	find . -name '*.go' -not -path './vendor/*' -not -path './_repos/*' | xargs misspell -error
	@echo ""

# Clean all golang files and packages generated in some build process.
.PHONY: gclean
gclean:
	@echo "==> Cleaning..."
	go clean -x -i ${SRC}
	rm -rf ./bin/*
	rm -rf ./vendor
	rm -rf ./dist
	rm -rf *.tar.gz
	@echo ""

# Docker/Docker-Compose shortcuts.
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
