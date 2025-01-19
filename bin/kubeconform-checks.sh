#!/bin/bash

set -eou pipefail

# Check if required tools are installed
for cmd in kubeconform yq kustomize kubectl jq; do
    if ! command -v $cmd &> /dev/null; then
        printf "Error: %s could not be found. Please install it first.\n" "$cmd"
        exit 1
    fi
done

# Get kubernetes minor version via kubectl
KUBERNETES_MINOR_VERSION=$(kubectl version --client=true -o=json | jq -r '.clientVersion.minor' | tr -d '+')
FLUX_VERSION=$(flux version --client | awk '{print $2}')

# Configuration
kubeconform_flags=("-skip=Secret")
kubeconform_config=("-strict" "-ignore-missing-schemas" "-schema-location" "default" "-schema-location" "/tmp/flux-schemas" "-schema-location" "/tmp/kubernetes-schemas" "-verbose" "-output" "pretty" "-exit-on-error")

function get_targets {
  find kustomize -maxdepth 3 -name kustomization.yaml -exec dirname {} \; | sort
}

# Loop through each environment
for env in $(get_targets); do
    printf "\n\nValidating kustomization in %s against Flux %s schemas and Kubernetes v1.%s.0 schemas\n" "${env#*/}" "${FLUX_VERSION}" "${KUBERNETES_MINOR_VERSION}"
    kustomize build "${env}" | kubeconform "${kubeconform_flags[@]}" "${kubeconform_config[@]}"
done

printf "\nValidation complete!\n"
exit 0
