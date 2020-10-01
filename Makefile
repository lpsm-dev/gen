MAKEFLAGS += --warn-undefined-variables

# Copyright 2020 The gen authors
#
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

export CLIENT_VERSION=$(CLIENT_VERSION)
export GO_VERSION=$(GO_VERSION)
export GIT_BRANCH=$(GIT_BRANCH)

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
	$(GO) mod download
	$(GO) generate -v ./...
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
	$(GO) install -x ${SRC}
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

# Running goreleaser
.PHONY: snapshot
snapshot:
	goreleaser --snapshot --rm-dist

# Clean all golang files and packages generated in some build process.
.PHONY: gclean
gclean:
	@echo "==> Cleaning..."
	$(GO) clean -x -i ${SRC}
	rm -rf ./bin/* ./vendor ./dist *.tar.gz
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
