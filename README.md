[![Greenpeace](https://circleci.com/gh/greenpeace/planet4-helm-esexporter.svg?style=shield)](https://circleci.com/gh/greenpeace/planet4-helm-esexporter)

![Planet4](./p4logo.png)
# Prometheus exporter for ElasticSearch

Prometheus exporter for various metrics about ElasticSearch, written in Go.

Learn more: https://github.com/justwatchcom/elasticsearch_exporter

<h1>Important Notes</h1>

>NOT currently deployed to the production cluster.

***
### Requirements - Internal Only
-   Access to P4 Infra [environment](https://www.notion.so/p4infra/bab9d0b1f2db4d929a59916899d531c1?v=eca7b78e1ae345c6883a9b37c6b76cac)

### Built with
- [prometheus-elasticsearch-exporter](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-elasticsearch-exporter) helm chart

### Deployment
This repository is deployed via [CircleCI](https://circleci.com/gh/greenpeace/planet4-traefik)

 - Commits to the develop branch trigger deployment to the development cluster.  
 - Create a PR for review to prepare for production deployment.
 - Approval and merge deploys to production.

### Usage
 - Access Grafana [here](https://grafana.p4.greenpeace.org/?orgId=1)
 - Clone the repo to access makefile commands via cli that are not executed via CircleCI
   - `make status` - <em> display status of named release </em>
   - `make value` - <em> display user values followed by all values deployed </em>
   - `make history` - <em> display deployment history of named release </em>
   - `make uninstall` - <em> delete release while retaining history, CRDs, PVs etc.</em>
   - `make destroy` - <em> destroy release including CRDs, PVs etc. </em> <strong> CAUSES DATA LOSS </strong>

 ### Infra Documentation
 - External
   - [Planet 4 Handbook](https://app.gitbook.com/@greenpeace/s/planet4/infrastructure/intro)
 - Internal use only
   - [P4 Notion](https://www.notion.so/p4infra/)
   - [P4 Google Site](https://sites.google.com/greenpeace.org/p4-infra)

 ### Contributing
 If your interested in contributing to P4 Infrastructure code please check our our community page [here](https://github.com/greenpeace/planet4).
