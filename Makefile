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

export CLIENT_VERSION = $(CLIENT_VERSION)
export GO_VERSION    	= $(GO_VERSION)
export GIT_BRANCH			= $(GIT_BRANCH)

#################################################
# Includes
#################################################

include Makefile.variables
include Makefile.docker

#################################################
# Helper
#################################################

.PHONY: help
help:
	@echo "Management commands for cicdtest:"
	@echo ""
	@echo "Usage:"
	@echo ""
	@echo "** Golang Commands **"
	@echo ""
	@echo "make setup"
	@echo "make build"
	@echo "make install"
	@echo "make lint"
	@echo "make misspell"
	@echo "make clean"
	@echo ""
	@echo "** Docker Commands **"
	@echo ""
	@echo "make docker-stop"
	@echo "make docker-remove"
	@echo "make docker-volume-prune"
	@echo "make docker-network-prune"
	@echo "make docker-system-prune"
	@echo "make docker-clean"
	@echo "make docker-deep-clean"
	@echo ""
	@echo "** Docker Compose Commands **"
	@echo ""
	@echo "make compose-up"
	@echo "make compose-up-background"
	@echo "make compose-down"
	@echo "make compose-ps"
	@echo "make compose-run"
	@echo "make compose-run-background"
	@echo ""

#################################################
# GoLang shortcuts
#################################################

.PHONY: setup
setup:
	@echo "==> Setup..."
	$(GO) mod download
	$(GO) generate -v ./...
	@echo ""

.PHONY: build
build: 
	@echo "==> Building..."
	$(GOBUILD) -o $(BINDIR)/$(BINNAME) -ldflags '$(LDFLAGS)' main.go
	@echo ""

.PHONY: install
install:
	@echo "==> Installing..."
	$(GO) install -x ${SRC}
	@echo ""

.PHONY: lint
lint:
	@echo "==> Running lint..."
	golint -set_exit_status ./...

.PHONY: misspell
misspell:
	@# misspell - Correct commonly misspelled English words in source files
	@#    go get -u github.com/client9/misspell/cmd/misspell
	@echo "==> Runnig misspell ..."
	find . -name '*.go' -not -path './vendor/*' -not -path './_repos/*' | xargs misspell -error
	@echo ""

.PHONY: snapshot
snapshot:
	goreleaser --snapshot --rm-dist

.PHONY: clean
clean:
	@echo "==> Cleaning..."
	$(GO) clean -x -i ${SRC}
	rm -rf ./bin/* ./vendor ./dist *.tar.gz
	@echo ""
