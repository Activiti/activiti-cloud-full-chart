CURRENT=$(pwd)
NAME := activiti-cloud-full-example
OS := $(shell uname)
RELEASE_VERSION := $(shell cat ../../VERSION)

GITHUB_CHARTS_REPO := $(or $(GITHUB_CHARTS_REPO),$(shell git config --get remote.origin.url))
GITHUB_CHARTS_BRANCH := $(or $(GITHUB_CHARTS_BRANCH),gh-pages)
ORG:=$(or $(ORG),activiti)

build: clean
	helm init --client-only
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts/
	helm dependency build
	helm lint

install: clean build
	sed -i -e "s/jx-staging/${PREVIEW_NAMESPACE}/g" values.yaml
	helm install . --set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} --name ${HELM_RELEASE_NAME} --namespace ${PREVIEW_NAMESPACE} --debug --wait 

install-security: clean build
	sed -i -e "s/jx-staging/${PREVIEW_NAMESPACE}/g" values-security.yaml
	helm install . -f values-security.yaml --set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} --name ${HELM_RELEASE_NAME}-security --namespace ${PREVIEW_NAMESPACE} --debug --wait 

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
	sed -i -e "s/${PREVIEW_NAMESPACE}/jx-staging/g" values.yaml  
	helm package .
#	curl  -u $(CHARTMUSEUM_CREDS_USR):$(CHARTMUSEUM_CREDS_PSW) --data-binary "@$(NAME)-$(shell sed -n 's/^version: //p' Chart.yaml).tgz" $(CHART_REPO)/api/charts
	rm -rf ${NAME}*.tgz%

github:
	$(eval GITHUB_CHARTS_DIR := $(shell basename $(GITHUB_CHARTS_REPO) .git))
	[[ -d $(GITHUB_CHARTS_DIR) ]] ||git clone -b "$(GITHUB_CHARTS_BRANCH)" "$(GITHUB_CHARTS_REPO)" $(GITHUB_CHARTS_DIR)
	cp "$(NAME)-$(RELEASE_VERSION).tgz" $(GITHUB_CHARTS_DIR)
	cd $(GITHUB_CHARTS_DIR) && \
	   helm repo index . && \
	   git add . && \
	   git status && \
	   git commit -m "fix:(version) release $(NAME)-$(RELEASE_VERSION).tgz" && \
	   git pull && \
	   git push origin "$(GITHUB_CHARTS_BRANCH)"
	rm -rf $(GITHUB_CHARTS_DIR)

tag:
ifeq ($(OS),Darwin)
	sed -i "" -e "s/version:.*/version: $(RELEASE_VERSION)/" Chart.yaml
	sed -i "" -e "s/tag: .*/tag: $(RELEASE_VERSION)/" values.yaml
else ifeq ($(OS),Linux)
	sed -i -e "s/version:.*/version: $(RELEASE_VERSION)/" Chart.yaml
#	sed -i -e "s|repository: .*|repository: $(DOCKER_REGISTRY)/$(ORG))/$(NAME)|" values.yaml
	sed -i -e "s/tag: .*/tag: $(RELEASE_VERSION)/" values.yaml
else
	echo "platfrom $(OS) not supported to release from"
	exit -1
endif
	git add --all
	git commit -m "release $(RELEASE_VERSION)" --allow-empty # if first release then no verion update is performed
	git tag -fa v$(RELEASE_VERSION) -m "Release version $(RELEASE_VERSION)"
	git push origin v$(RELEASE_VERSION)
