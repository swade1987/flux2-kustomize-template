[![kustomize-checks](https://github.com/swade1987/flux2-kustomize-template/actions/workflows/kustomize-checks.yaml/badge.svg)](https://github.com/swade1987/flux2-kustomize-template/actions/workflows/kustomize-checks.yaml)

# Flux Kustomize Template

This is an opinionated Kustomize template to use as a starting point for new projects.

## Features

## Features

- Linting (via CI) using [kubeconform](https://github.com/yannh/kubeconform), [pluto](https://github.com/FairwindsOps/pluto) and [istioctl](https://istio.io/latest/docs/reference/commands/istioctl/).
    - Automated with GitHub Actions
- Commits must meet [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
    - Automated with GitHub Actions ([commit-lint](https://github.com/conventional-changelog/commitlint/#what-is-commitlint))
- Pull Request titles must meet [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
    - Automated with GitHub Actions ([semantic-lint](https://github.com/amannn/action-semantic-pull-request)

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
