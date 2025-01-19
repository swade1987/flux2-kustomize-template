#!/bin/bash

# shellcheck disable=SC1001

set -euo pipefail

EXIT_CODE=0

function get_targets {
  find . -maxdepth 4 -name kustomization.yaml -exec dirname {} \;
}

for env in $(get_targets); do
  printf "\nChecking %s\n" "${env#*/}"
  dupes=$(
  	cd "${env}" ; \
    kustomize build . | \
    yq e --no-doc --unwrapScalar=false '.spec.releaseName' - | \
    grep -v null | \
    sed 's/^-\ //g' | \
    sort | \
    uniq -d
  )

  if [[ $(wc -w <<< "$dupes") == 0 ]]; then
    echo "OK"
  else
    echo "  Duplicates found:"
    printf "    %s" "$dupes"
    EXIT_CODE=1
  fi
done

exit $EXIT_CODE
