# Security Policy

## Supported versions

This template ships one rolling `latest` semantic-release version; there's no long-term-support branch to track. Fixes land on `main` and are published as the next tagged release.

## Reporting a vulnerability

Please report security issues privately rather than opening a public GitHub issue: use [GitHub's private vulnerability reporting](https://github.com/swade1987/flux2-kustomize-template/security/advisories/new) for this repository (Security tab → Report a vulnerability).

Include what you'd include in any good bug report: the affected version or commit, what you found, and how to reproduce it. We'll acknowledge new reports within 5 business days and aim to have a fix or mitigation plan within 30 days, depending on severity.

## Scope

This is a GitOps repository template - the CI checks (kubeconform, pluto, istio-checks, duplicate-release-name-checks, kustomize-diff) and the scripts under `bin/` are in scope. The example Kubernetes manifests under `kustomize/` are illustrative content, not a security boundary.
