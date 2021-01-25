SHELL := /bin/bash

RELEASE := es-exp
NAMESPACE := kube-system

CHART_NAME ?= prometheus-community/prometheus-elasticsearch-exporter
CHART_VERSION ?= 4.0.1

DEV_CLUSTER ?= p4-development
DEV_PROJECT ?= planet-4-151612
DEV_ZONE ?= us-central1-a

PROD_CLUSTER ?= planet4-production
PROD_PROJECT ?= planet4-production
PROD_ZONE ?= us-central1-a

.DEFAULT_TARGET: status

lint: lint-yaml lint-ci

lint-yaml:
	@find . -type f -name '*.yml' | xargs yamllint
	@find . -type f -name '*.yaml' | xargs yamllint

lint-ci:
	@circleci config validate

# Helm Initialisation
init:
	helm3 repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm3 repo update

# Helm Deploy to Development
dev: lint init
ifndef CI
	$(error Please commit and push, this is intended to be run in a CI environment)
endif
	gcloud config set project $(DEV_PROJECT)
	gcloud container clusters get-credentials $(DEV_CLUSTER) --zone $(DEV_ZONE) --project $(DEV_PROJECT)
	-kubectl create namespace $(NAMESPACE)
	helm3 upgrade --install --wait $(RELEASE) \
		--namespace=$(NAMESPACE) \
		--version $(CHART_VERSION) \
		-f values.yaml \
		$(CHART_NAME)
	$(MAKE) history

# Helm Deploy to Production
prod: lint init
ifndef CI
	$(error Please commit and push, this is intended to be run in a CI environment)
endif
	gcloud config set project $(PROD_PROJECT)
	gcloud container clusters get-credentials $(PROD_PROJECT) --zone $(PROD_ZONE) --project $(PROD_PROJECT)
	-kubectl create namespace $(NAMESPACE)
	helm3 upgrade --install --wait $(RELEASE) \
		--namespace=$(NAMESPACE) \
		--version $(CHART_VERSION) \
		-f values.yaml \
		$(CHART_NAME)
	$(MAKE) history

# Helm status
status:
	helm3 status $(CHART_NAME) -n $(NAMESPACE)

# Display user values followed by all values
values:
	helm3 get values $(CHART_NAME) -n $(NAMESPACE)
	helm3 get values $(CHART_NAME) -n $(NAMESPACE) -a

# Display helm history
history:
	helm3 history $(RELEASE) -n $(NAMESPACE) --max=5

# Delete a release when you intend reinstalling it to keep history
uninstall:v
	helm3 uninstall $(RELEASE) -n $(NAMESPACE) --keep-history

# Completely remove helm install, config data, persistent volumes etc.
# Before running this ensure you have deleted any other related config
destroy:
	helm3 uninstall $(RELEASE) -n $(NAMESPACE)
