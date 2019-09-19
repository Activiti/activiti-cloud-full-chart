CURRENT=$(pwd)
NAME := activiti-cloud-full-example
OS := $(shell uname)
RELEASE_VERSION := $(or $(shell cat ../../VERSION),$(APP_ACTIVITI_VERSION))
HELM_ACTIVITI_VERSION := $(or $(HELM_ACTIVITI_VERSION),$(RELEASE_VERSION))

GITHUB_CHARTS_REPO := $(or $(GITHUB_CHARTS_REPO),$(shell git config --get remote.origin.url))
GITHUB_CHARTS_BRANCH := $(or $(GITHUB_CHARTS_BRANCH),gh-pages)
ORG:=$(or $(ORG),activiti)

printrelease:
	echo RELEASE_VERSION $(RELEASE_VERSION)
	echo HELM_ACTIVITI_VERSION $(HELM_ACTIVITI_VERSION)
	echo APP_ACTIVITI_VERSION $(APP_ACTIVITI_VERSION)

build: clean
	helm init --client-only
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts/
	helm repo add alfresco https://kubernetes-charts.alfresco.com/stable
	helm repo add alfresco-incubator https://kubernetes-charts.alfresco.com/incubator
	helm dependency build
	helm lint

install: clean build
	helm upgrade ${HELM_RELEASE_NAME} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--namespace ${PREVIEW_NAMESPACE} \
		--debug \
		--wait 

upgrade: clean build
	helm upgrade ${HELM_RELEASE_NAME} .

delete:
	helm delete --purge ${HELM_RELEASE_NAME}

delete-security:
	helm delete --purge ${HELM_RELEASE_NAME}-security

clean:
	rm -rf requirements.lock
	rm -rf charts
	rm -rf ${NAME}*.tgz

release: build
	helm package .


github:
	$(eval GITHUB_CHARTS_DIR := $(shell basename $(GITHUB_CHARTS_REPO) .git))
	[[ -d $(GITHUB_CHARTS_DIR) ]] ||git clone -b "$(GITHUB_CHARTS_BRANCH)" "$(GITHUB_CHARTS_REPO)" $(GITHUB_CHARTS_DIR)
	cp "$(NAME)-$(HELM_ACTIVITI_VERSION).tgz" $(GITHUB_CHARTS_DIR)
	cd $(GITHUB_CHARTS_DIR) && \
	   helm repo index . && \
	   git add . && \
	   git status && \
	   git commit -m "fix:(version) release $(NAME)-$(HELM_ACTIVITI_VERSION).tgz" && \
	   git pull && \
	   git push origin "$(GITHUB_CHARTS_BRANCH)"
	rm -rf $(GITHUB_CHARTS_DIR)

tag:
	sed -i -e "s/version:.*/version: $(HELM_ACTIVITI_VERSION)/" Chart.yaml
	sed -i -e "s/tag: .*/tag: $(RELEASE_VERSION)/" values.yaml

	git add Chart.yaml values.yaml requirements.yaml
	git commit -m "release $(HELM_ACTIVITI_VERSION)" --allow-empty # if first release then no verion update is performed
	git tag -fa v$(HELM_ACTIVITI_VERSION) -m "Release version $(HELM_ACTIVITI_VERSION)"
	git push origin v$(HELM_ACTIVITI_VERSION)

updatebot/push-version: 	
	cd ../../ && updatebot push-version --kind helm  $(NAME) $(HELM_ACTIVITI_VERSION)
