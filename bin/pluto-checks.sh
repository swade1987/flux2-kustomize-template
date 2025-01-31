#!/bin/bash

set -eou pipefail

# Check if required tools are installed
for cmd in yq pluto kustomize kubectl jq; do
    if ! command -v $cmd &> /dev/null; then
        printf "Error: %s could not be found. Please install it first.\n" "$cmd"
        exit 1
    fi
done

# Get kubernetes minor version via kubectl
KUBERNETES_VERSION=$(kubectl version --client=true -o=json | jq -r '.clientVersion.gitVersion')
PLUTO_VERSION=$(pluto version | sed 's/Version://' | awk '{print $1}')

function get_targets {
  find kustomize -maxdepth 2 -name kustomization.yaml -exec dirname {} \; | sort
}

# Loop through each environment
for env in $(get_targets); do
    printf "\n\nValidating %s for deprecations against Kubernetes version: %s using pluto: %s ... \n\n" "${env#*/}" "${KUBERNETES_VERSION}" "${PLUTO_VERSION}"
    kustomize build "${env}"| pluto detect -t "k8s=${KUBERNETES_VERSION}" --output=wide --no-footer -
    printf "\n"
done

printf "\nValidation complete!\n"
exit 0
