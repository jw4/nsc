NAME=nsc
IMAGE=docker.w.jw4.us/nsc

ifeq ($(ROOT_IMPORT_PATH),)
	ROOT_IMPORT_PATH="jw4.us/nsc"
endif

ifeq ($(CMD_REL_PATH),)
	CMD_REL_PATH="."
endif

ifeq ($(BUILD_VERSION),)
	BUILD_VERSION := $(shell git describe --dirty --first-parent --always --tags)
endif

.PHONY: all
all: image

.PHONY: clean
clean:
	@-rm ./app ./nsc
	-go clean ./...
	-rm -rf vendor

.PHONY: local
local:
	@go mod vendor
	@CGO_ENABLED=0 \
		go build -a \
			-mod=vendor \
			-tags netgo \
			-ldflags="-s -w -extldflags -static -X ${ROOT_IMPORT_PATH}.Version=${BUILD_VERSION}" \
			-o app \
		${CMD_REL_PATH}

.PHONY: image
image:
	@go mod vendor
	@docker build \
			--compress \
			--no-cache \
			--squash \
			--force-rm \
			--build-arg ROOT_IMPORT_PATH=$(ROOT_IMPORT_PATH) \
			--build-arg CMD_REL_PATH=$(CMD_REL_PATH) \
			--build-arg BUILD_VERSION=$(BUILD_VERSION) \
			-t $(IMAGE):latest \
			-t $(IMAGE):$(BUILD_VERSION) \
		.

.PHONY: push
push: clean image
	docker push $(IMAGE):$(BUILD_VERSION)
	docker push $(IMAGE):latest
