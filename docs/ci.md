# CI

The following sections detail the CI tasks which run as part of this repository.

All configuration for CI can be found within the `.github/workflows/kustomize-checks.yaml` files of this repository.

These all execute as Github actions and the scripts can be found in the `bin` directory of this repository.

## duplicate-release-name-checks

Within a cluster all `HelmRelease` resources need to be uniquely named.

The script can be found [here](../bin/check-duplicate-release-name.sh).

This script is executed within our `kubernetes-toolkit` container which can be found [here](https://github.com/swade1987/kubernetes-toolkit).

## kubeconform

We validate the resources within each sub-directory under the `kustomize` directory against the JSON schema definitions for:

1. The version of Kubernetes we are using.
2. The version of [flux](https://github.com/fluxcd/flux2) we are using.

This is made possible by leveraging a tool called [kubeconform](https://github.com/yannh/kubeconform).

The script can be found [here](../bin/kubeconform-checks.sh).

These checks are executed within our `kubernetes-toolkit` container which can be found [here](https://github.com/swade1987/kubernetes-toolkit).

## pluto

Throughout the evolution of Kubernetes the API versions that specific resources use become deprecated.

A prime example of this was the API versions that became deprecated as part of the 1.16 release see [here](https://kubernetes.io/blog/2019/07/18/api-deprecations-in-1-16/) for more information.

Therefore, to remain ahead of the curve we want to be making sure we are not using deprecated API versions within our helm charts prior to them being deployed to our EKS clusters.

This is made possible by leveraging Pluto which can be found [here](https://github.com/FairwindsOps/pluto).

The script used to validate this, can be found [here](../bin/pluto-checks.sh).

This script is executed within our `kubernetes-toolkit` container which can be found [here](https://github.com/swade1987/kubernetes-toolkit).

## istio-checks

We validate the resources within each sub-directory under the `environments` directory against the JSON schema definitions for the version of Istio we are using.

This is made possible by leveraging a tool called `istioctl` which can be found [here](https://istio.io/latest/docs/reference/commands/istioctl/).

The script used to validate this, can be found [here](../bin/istio-checks.sh).

This script is executed within our `kubernetes-toolkit` container which can be found [here](https://github.com/swade1987/kubernetes-toolkit).

## kustomize-yaml-check

We also validate each `kustomization.yaml` file within the repository to make sure it aligns with the recommended structure.

The script used to validate this, can be found [here](https://github.com/swade1987/kubernetes-toolkit/blob/master/bin/kustomization-yaml-fix).

This script is executed within our `kubernetes-toolkit` container which can be found [here](https://github.com/swade1987/kubernetes-toolkit).

## kustomize-diff

As we are using `kustomize` the changes made as part of a Pull Request got execute a number of changes across multiple clusters.

This job is responsible for obtaining those changes and printing them as a comment on the Pull Request to make reviewal easier.

The job uses the following two GitHub Actions

- [swade1987/github-action-kustomize-diff](https://github.com/swade1987/github-action-kustomize-diff)
- [actions/github-script](https://github.com/actions/github-script)
