#!/bin/bash

set -euo pipefail

mkdir -p /tmp/kustomize

for env in kustomize/overlays/*; do
  if [ "$env" == 'kustomize/_base' ]; then continue ; fi

  printf "\nChecking %s\n" "${env#*/}"

  kustomize build "${env}"  > /tmp/"${env}".yaml

  istioctl validate -f /tmp/"${env}".yaml

done
