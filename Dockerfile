# FROM bufbuild/buf:latest AS buf
# FROM python:3.11-slim
FROM ubuntu:22.04

# Install common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG BUF_BIN="/usr/local/bin/buf"
ARG BUF_VERSION=1.54.0 
RUN curl -sSL https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m) -o ${BUF_BIN} && chmod +x ${BUF_BIN}

# Install protobuf compiler
ARG PROTOC_VERSION=31.0
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip \
    && unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d /usr/local \
    && rm protoc-${PROTOC_VERSION}-linux-x86_64.zip

# ===== C++ dependencies ===== 
RUN apt-get update && apt-get install -y \
    g++ \
    cmake \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ===== Python & Django dependencies ===== 
ARG GRPC_VERSION=1.72.0
ARG GRPC_TOOLS_VERSION=1.72.0
ARG PY_PROTOBUF_VERSION=6.31.0
ARG DJANGO_GRPC_VERSION=0.2.1
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install django grpcio==${GRPC_VERSION} grpcio-tools==${GRPC_TOOLS_VERSION} \
       protobuf==${PY_PROTOBUF_VERSION} djangogrpcframework==${DJANGO_GRPC_VERSION}

# Create wrapper for grpc_python_django plugin. Note: ensure that the path in buf.gen.yaml matches.
RUN echo '#!/bin/sh\nexec python3 -m grpc_tools.protoc "$@"' > /usr/local/bin/protoc-gen-grpc_python_django \
 && chmod +x /usr/local/bin/protoc-gen-grpc_python_django

# ===== JavaScript dependencies =====
# Install Node.js and grpc_tools_node_protoc_plugin
ARG JS_GRPC_TOOLS_VERSION=1.13.0
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g grpc-tools@${JS_GRPC_TOOLS_VERSION}

# Install protoc-gen-grpc-web for JavaScript/Browser. Note: ensure that the path in buf.gen.yaml matches.
ARG GRPC_WEB_VERSION=1.5.0
RUN curl -LO https://github.com/grpc/grpc-web/releases/download/${GRPC_WEB_VERSION}/protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 \
    && chmod +x protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 \
    && mv protoc-gen-grpc-web-${GRPC_WEB_VERSION}-linux-x86_64 /usr/local/bin/protoc-gen-grpc-web

# Create symbolic links for C++, Python, Django, and JavaScript protoc plugins. Note: ensure that the paths in buf.gen.yaml match.
RUN ln -s /usr/local/bin/protoc /usr/local/bin/protoc-gen-cpp \
 && ln -s /usr/bin/python3 /usr/local/bin/protoc-gen-python \
 && ln -s /usr/local/bin/grpc_tools_node_protoc_plugin /usr/local/bin/protoc-gen-js

# Copy buf from the first stage
# COPY --from=buf /usr/local/bin/buf /usr/local/bin/buf

WORKDIR /workspace

# Make sure we have a bash shell available
# RUN apt-get update && apt-get install -y bash && apt-get clean

# RUN buf generate --debug
ENTRYPOINT ["buf"]
# CMD ["generate", "--debug"]
# CMD ["format", "--debug"]
# CMD ["--help"]
