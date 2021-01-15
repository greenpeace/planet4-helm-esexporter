SHELL := /bin/bash

RELEASE_NAME := es-exp
NAMESPACE := kube-system

CHART_NAME ?= prometheus-community/prometheus-elasticsearch-exporter
CHART_VERSION ?= 4.0.1

DEV_CLUSTER ?= p4-development
DEV_PROJECT ?= planet-4-151612
DEV_ZONE ?= us-central1-a

PROD_CLUSTER ?= planet4-production
PROD_PROJECT ?= planet4-production
PROD_ZONE ?= us-central1-a

lint:
	@yamllint .circleci/config.yml
	@yamllint values.yaml

init:
	helm init --client-only
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

dev: init lint
	gcloud config set project $(DEV_PROJECT)
	gcloud container clusters get-credentials $(DEV_CLUSTER) --zone $(DEV_ZONE) --project $(DEV_PROJECT)
	helm upgrade --install --force --wait $(RELEASE_NAME) \
		--namespace=$(NAMESPACE) \
		--version $(CHART_VERSION) \
		-f values.yaml \
		$(CHART_NAME)

prod: lint
	gcloud config set project $(PROD_PROJECT)
	gcloud container clusters get-credentials $(PROD_CLUSTER) --zone $(PROD_ZONE) --project $(PROD_PROJECT)
	helm init --client-only
	helm repo update
	helm upgrade --install --force --wait $(RELEASE_NAME) \
		--namespace=$(NAMESPACE) \
		--version $(CHART_VERSION) \
		-f values.yaml \
		$(CHART_NAME)

history:
	helm history $(RELEASE_NAME) --max=10
