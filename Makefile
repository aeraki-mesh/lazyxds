# Copyright Aeraki Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Go parameters
GOCMD?=go
GOBUILD?=$(GOCMD) build
GOTEST?=$(GOCMD) test
GOCLEAN?=$(GOCMD) clean
GOTEST?=$(GOCMD) test
GOGET?=$(GOCMD) get
GOBIN?=$(GOPATH)/bin
GOMOD?=$(GOCMD) mod

# Build parameters
IMAGE_TAG := $(tag)

ifeq ($(IMAGE_TAG),)
IMAGE_TAG := latest
endif

OUT?=./out
DOCKER_TMP?=$(OUT)/docker_temp/

# lazyxds
LAZYXDS_DOCKER_TAG?=aeraki/lazyxds:$(IMAGE_TAG)
LAZYXDS_DOCKER_TAG_E2E?=aeraki/lazyxds:`git log --format="%H" -n 1`
LAZYXDS_BINARY_NAME?=$(OUT)/lazyxds
LAZYXDS_BINARY_NAME_DARWIN?=$(LAZYXDS_BINARY_NAME)-darwin
LAZYXDS_MAIN?=./cmd/lazyxds/main.go

test: style-check
	$(GOMOD) tidy
	$(GOTEST) -race  `go list ./... | grep -v e2e`
clean:
	rm -rf $(OUT)
style-check:
	gofmt -l -d ./
	goimports -l -d ./
lint:
	golint ./...
	golangci-lint run --tests="false"
build.lazyxds: test
	CGO_ENABLED=0 GOOS=linux  $(GOBUILD) -o $(LAZYXDS_BINARY_NAME) $(LAZYXDS_MAIN)
build-mac.lazyxds: test
	CGO_ENABLED=0 GOOS=darwin  $(GOBUILD) -o $(LAZYXDS_BINARY_NAME_DARWIN) $(LAZYXDS_MAIN)
docker-build.lazyxds: build.lazyxds
	rm -rf $(DOCKER_TMP)
	mkdir $(DOCKER_TMP)
	cp ./lazyxds/docker/Dockerfile $(DOCKER_TMP)
	cp $(LAZYXDS_BINARY_NAME) $(DOCKER_TMP)
	docker build -t $(LAZYXDS_DOCKER_TAG) $(DOCKER_TMP)
	rm -rf $(DOCKER_TMP)
docker-push.lazyxds: docker-build.lazyxds
	docker push $(LAZYXDS_DOCKER_TAG)
docker-build-e2e.lazyxds: build.lazyxds
	rm -rf $(DOCKER_TMP)
	mkdir $(DOCKER_TMP)
	cp ./lazyxds/docker/Dockerfile $(DOCKER_TMP)
	cp $(LAZYXDS_BINARY_NAME) $(DOCKER_TMP)
	docker build -t $(LAZYXDS_DOCKER_TAG_E2E) $(DOCKER_TMP)
	rm -rf $(DOCKER_TMP)
e2e-lazyxds:
	ginkgo -v ./test/e2e/lazyxds/lazyxds/
.DEFAULT_GOAL := docker-build
