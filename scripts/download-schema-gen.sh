#!/usr/bin/env bash

set -e 

# Check if version argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <version> [destination]"
  echo "Example: $0 v1.7.3 proto/gen"
  exit 1
fi

DEST="${2:-.}"  # Set destination directory, default to the current directory

VERSION="$1"
REPO="fyn-tech/fyn-schema"

# Get the download URL of the first asset from the GitHub release for the given version
DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/${REPO}/releases/tags/${VERSION}" | jq -r '.assets[0].browser_download_url')

# Check if a valid download URL was found
if [ "$DOWNLOAD_URL" = "null" ]; then
  echo "Error: no artifacts found for version ${VERSION} in repo ${REPO}"
  exit 1
fi

# Create destination directory if it doesn't exist
if [ ! -d "$DEST" ]; then
  mkdir -p "$DEST"
fi

# Download and extract the protobuf artifacts
TAR_FILE="$DEST/proto_gen.tar.gz"
echo "Downloading protobuf artifacts from: $DOWNLOAD_URL"
curl -L -o "$TAR_FILE" "$DOWNLOAD_URL"
tar -xzf "$TAR_FILE" -C "$DEST"
rm "$TAR_FILE"
echo "Artifacts downloaded and extracted to: $DEST"