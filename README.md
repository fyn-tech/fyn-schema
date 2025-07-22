# fyn-schema

Schema definitions and API contracts for the Fyn-Tech ecosystem.

## Overview

This repository contains:
- **Protocol Buffers**: gRPC service definitions in `proto/`
- **OpenAPI Schemas**: REST API specifications in `schema/`
- **Generated Code**: Generated multi-language client/server stubs/skeletons in `gen/`

## Code Generation

Uses [buf](https://buf.build/) with Docker to generate client libraries from Protocol Buffer definitions.

**Supported Languages:**
- C++
- Python (with type stubs)
- JavaScript (gRPC-Web)

## Quick Start

```bash
make          # Generate all client libraries
make lint     # Validate proto files
make format   # Format proto files
```

## Commands

| Command | Description |
|---------|-------------|
| `make` | Clean, build, and generate all code |
| `make clean` | Remove generated code |
| `make build` | Build Docker image |
| `make generate` | Generate client libraries |
| `make lint` | Validate proto files |
| `make breaking` | Check for breaking changes |
| `make format` | Format proto files |

## Requirements

- Docker
- Make

## Structure

```
proto/           # Protocol Buffer definitions
├── hello/       # Hello service
└── hey/         # Hey service
schema/          # OpenAPI specifications
gen/             # Generated client libraries
├── cpp/         # C++ generated code
├── python/      # Python generated code
└── js/          # JavaScript generated code
```
