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
include Makefile.docker

.PHONY: help
help:
	@echo "Management commands for cicdtest:"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "## Golang Commands"
	@echo ""
	@echo "make setup"
	@echo "make build"
	@echo "make install"
	@echo "make lint"
	@echo "make misspell"
	@echo "make gclean"
	@echo ""
	@echo "## Docker/Docker Compose Commands"
	@echo ""
	@echo "make docker-stop"
	@echo "make docker-remove"
	@echo "make docker-volume-prune"
	@echo "make docker-network-prune"
	@echo "make docker-system-prune"
	@echo "make clean"
	@echo "make remove"
	@echo ""

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
