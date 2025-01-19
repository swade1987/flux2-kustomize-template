#!/usr/bin/env bash

set -euo pipefail

KUSTOMIZE_VERSION=$1

# Check if kustomize is already installed with the correct version
if command -v kustomize >/dev/null 2>&1; then
    CURRENT_VERSION=$(kustomize version)
    if [[ "$CURRENT_VERSION" == "$KUSTOMIZE_VERSION" ]]; then
        echo "kustomize ${KUSTOMIZE_VERSION} is already installed"
        exit 0
    fi
    echo "Current kustomize version: ${CURRENT_VERSION}"
    echo "Requested version: ${KUSTOMIZE_VERSION}"
fi

# Determine OS and architecture
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
[[ "$ARCH" == "x86_64" ]] && ARCH="amd64"
[[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

# Create temp directory and clean it up on exit
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Installing kustomize ${KUSTOMIZE_VERSION}..."

# Download and extract kustomize
DOWNLOAD_URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${OS}_${ARCH}.tar.gz"
curl -SL "$DOWNLOAD_URL" | tar xz -C "$TMP_DIR"

# Install kustomize to /usr/local/bin (requires sudo)
if [[ -w "/usr/local/bin" ]]; then
    mv "$TMP_DIR/kustomize" "/usr/local/bin/"
else
    sudo mv "$TMP_DIR/kustomize" "/usr/local/bin/"
fi

# Verify installation
if kustomize version | grep -q "${KUSTOMIZE_VERSION}"; then
    echo "Successfully installed kustomize ${KUSTOMIZE_VERSION}"
else
    echo "Failed to install kustomize ${KUSTOMIZE_VERSION}"
    exit 1
fi
