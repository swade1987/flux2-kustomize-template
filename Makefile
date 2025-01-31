CURRENT_WORKING_DIR=$(shell pwd)

GOOS          ?= $(if $(TARGETOS),$(TARGETOS),linux)
GOARCH        ?= $(if $(TARGETARCH),$(TARGETARCH),amd64)
BUILDPLATFORM ?= $(GOOS)/$(GOARCH)

TOOLKIT_IMAGE := eu.gcr.io/swade1987/kubernetes-toolkit:1.2.0
KUSTOMIZE_VERSION := v5.4.3

# ############################################################################################################

initialise:
	@echo "Installing required kustomize version"
	./bin/install-tools.sh $(KUSTOMIZE_VERSION)
	@echo "Initialising pre-commit hooks"
	pre-commit --version || brew install pre-commit
	pre-commit install --install-hooks
	pre-commit run -a

# ############################################################################################################
# Local tasks
# ############################################################################################################

local-check-duplicate-release-name:
	clear
	docker run --rm --platform $(BUILDPLATFORM) --name check-duplicate-release-name -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/check-duplicate-release-name.sh`"

local-kubeconform-checks:
	clear
	docker run --rm --platform $(BUILDPLATFORM) --name kubeconform -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/kubeconform-checks.sh`"

local-pluto-checks:
	clear
	docker run --rm --platform $(BUILDPLATFORM) --name pluto -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/pluto-checks.sh`"

local-istio-checks:
	clear
	docker run --rm --platform $(BUILDPLATFORM) --name istio-checks -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) bash -c "`cat bin/istio-checks.sh`"

local-kustomization-yaml-fix:
	clear
	docker run --rm --platform $(BUILDPLATFORM) --name kustomization-yaml-fix -v $(CURRENT_WORKING_DIR)/kustomize:/kustomize $(TOOLKIT_IMAGE) kustomization-yaml-fix /kustomize

# Usage make diff-env a=sbx b=bh
.PHONY: diff-env
diff-env:
	@git diff --no-index kustomize/{$(a),$(b)}

test-%:
	mkdir -p _test
	kustomize build kustomize/$* > _test/$*.yaml
	@echo
	@echo The output can be found at _test/$*.yaml

# ############################################################################################################
# CI tasks
# ############################################################################################################

duplicate-release-name-check:
	./bin/check-duplicate-release-name.sh

kubeconform-checks:
	./bin/kubeconform-checks.sh

pluto-checks:
	./bin/pluto-checks.sh

istio-checks:
	./bin/istio-checks.sh
