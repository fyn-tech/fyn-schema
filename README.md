# fyn-schema

This repository contains the schema definitions shared with all other repositories in the [fyn-tech](https://github.com/fyn-tech) environment. 

# Proto Generation with buf and Docker

This setup generates gRPC code from Protocol Buffer definitions using the [buf](https://buf.build/) tool within a Docker container. The following languages are supported:

- C++
- Python 
- Django
- JavaScript

## Requirements

- Make
- Docker

## Setup

1. Ensure you have Docker installed
2. Place your `.proto` files in their respective directories inside the `proto` directory.
3. Services must be defined in directories ending with `_service` (convention, not requirement). 
4. Run `make` (or `make generate`) to generate code for all languages

## Available Commands

```bash
make          # Clean, build Docker image, and generate code
make clean    # Remove and recreate generated code directories
make build    # Build the Docker image
make generate # Generate code using buf in Docker
make lint     # Lint .proto files using buf in Docker
make breaking # Check for breaking changes using buf in Docker
make format   # Format .proto files using buf in Docker
```

## Customization

- Modify `buf.gen.yaml` to change code generation options or add more languages
- Update the Dockerfile if you need additional tools in the build environment
- Adjust the Makefile to customize the build process
