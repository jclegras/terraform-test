# import deploy config
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# DOCKER TASKS
# Build the container
build:
	docker build -t $(APP_NAME) .

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{VERSION}` and `latest` tags

tag-latest:
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(REPOSITORY)/$(APP_NAME):latest

tag-version:
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(REPOSITORY)/$(APP_NAME):$(VERSION)

# Docker publish
publish: repo-login publish-latest publish-version ## Publish the `{VERSION}` and `latest` tagged containers to the registry


publish-latest: tag-latest ## Publish the `latest` tagged container to the registry
	@echo 'publish latest to $(REPOSITORY)'
	docker push $(REPOSITORY)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` tagged container to the registry
	@echo 'publish $(VERSION) to $(REPOSITORY)'
	docker push $(REPOSITORY)/$(APP_NAME):$(VERSION)

# Login to the remote registry
repo-login:
	@docker login

# Output the current version
version:
	@echo $(VERSION)

# Terraform tasks

# Terraform deploy this app
deploy: ## Deploy this app
	cd deploy-app && terraform apply

# Terraform plan this app
deploy-check: ## Deploy this app (check mode)
	cd deploy-app && terraform plan

rm: ## Destroy this app
	cd deploy-app && terraform destroy
