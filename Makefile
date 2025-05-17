# Makefile for generating gRPC code from protobuf files. Docker is used to run the protoc compiler in a container and the generated code is written to the 'gen' directory.

.PHONY: build generate clean

DOCKER_IMAGE := fyn-schema-generator
OUT_DIR := gen
# LANGUAGES := cpp python django js

# Default target
all: generate

# Build the Docker image
build:
	@echo "Building Docker image $(DOCKER_IMAGE)..."
	@docker build -t $(DOCKER_IMAGE) .

# Generate code using the Docker container
generate: build
	@echo "Generating gRPC code from proto files..."
# @mkdir -p $(addprefix $(OUT_DIR)/, $(LANGUAGES))
	@docker run --rm -v $(PWD):/workspace $(DOCKER_IMAGE) generate

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -rf $(OUT_DIR)
