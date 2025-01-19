[![kustomize-checks](https://github.com/stevenwadeconsulting/flux2-kustomize-example/actions/workflows/kustomize-checks.yaml/badge.svg)](https://github.com/stevenwadeconsulting/flux2-kustomize-example/actions/workflows/kustomize-checks.yaml)

# flux2-kustomize-template

A centralised location for all HelmReleases which make up the `<organisation>` application.

## Getting started

Before working with the repository it is **mandatory** to execute the following command:

```
make initialise
```

The above command will install the `pre-commit` package and setup pre-commit checks for this repository.

## How does this repository work?

This repo is driven by [Flux](https://fluxcd.io/).

## Continuous Integration

For more information on how CI for this repo works, please see [here](docs/ci.md)

## Local CI

To run the CI checks locally, you can use the following command:

```bash
make local-check-duplicate-release-name
make local-kubeconform-checks
make local-pluto-checks
make local-istio-checks
make local-kustomization-yaml-fix
```
