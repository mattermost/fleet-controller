# Copyright (c) 2015-present Mattermost, Inc. All Rights Reserved.
# See LICENSE.txt for license information.

## Docker Build Versions
DOCKER_BUILD_IMAGE = golang:1.15.7
DOCKER_BASE_IMAGE = alpine:3.13

# Variables
GO = go
APP := fleet-controller
APPNAME := fleet-controller
FLEET_CONTROLLER_IMAGE ?= mattermost/fleet-controller:test

# Build variables
COMMIT_HASH ?= $(shell git rev-parse HEAD)
BUILD_DATE  ?= $(shell date +%FT%T%z)

################################################################################

export GO111MODULE=on

all: check-style unittest

.PHONY: check-style
check-style: govet
	@echo Checking for style guide compliance

.PHONY: vet
govet:
	@echo Running govet
	$(GO) vet ./...
	@echo Govet success

.PHONY: unittest
unittest:
	$(GO) test ./... -v -covermode=count -coverprofile=coverage.out

# Build for distribution
.PHONY: build
build:
	@echo Building Mattermost Fleet Controller
	env GOOS=linux GOARCH=amd64 $(GO) build -o $(APPNAME) ./cmd/$(APP)

# Builds the docker image
.PHONY: build-image
build-image:
	@echo Building Fleet Controller Docker Image
	docker build \
	--build-arg DOCKER_BUILD_IMAGE=$(DOCKER_BUILD_IMAGE) \
	--build-arg DOCKER_BASE_IMAGE=$(DOCKER_BASE_IMAGE) \
	. -f build/Dockerfile \
	-t $(FLEET_CONTROLLER_IMAGE) \
	--no-cache
