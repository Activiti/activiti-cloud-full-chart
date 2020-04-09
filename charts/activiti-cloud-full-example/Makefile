CURRENT=$(pwd)
NAME := activiti-cloud-full-example
OS := $(shell uname)
RELEASE_VERSION := $(or $(shell cat ../../VERSION),$(APP_ACTIVITI_VERSION))
HELM_ACTIVITI_VERSION := $(or $(HELM_ACTIVITI_VERSION),$(RELEASE_VERSION))
PREVIEW_NAMESPACE_LOWERCASE | $(shell echo $PREVIEW_NAMESPACE| tr "[:upper:]" "[:lower:]")

GITHUB_CHARTS_REPO := $(or $(GITHUB_CHARTS_REPO),$(shell git config --get remote.origin.url))
GITHUB_CHARTS_BRANCH := $(or $(GITHUB_CHARTS_BRANCH),gh-pages)
ORG:=$(or $(ORG),activiti)
RELEASE_GREP_EXPR := '^[Rr]elease'

printrelease:
	echo RELEASE_VERSION $(RELEASE_VERSION)
	echo HELM_ACTIVITI_VERSION $(HELM_ACTIVITI_VERSION)
	echo APP_ACTIVITI_VERSION $(APP_ACTIVITI_VERSION)
	
update-ea:
	$(eval ACTIVITI_CLOUD_VERSION = $(shell make -f ../../Makefile get-cloud-dependencies-version)) 
	@echo "ACTIVITI_CLOUD_VERSION =<$(ACTIVITI_CLOUD_VERSION)>" 

	$(eval MODELING_DEPENDENCIES_VERSION = $(shell make -f ../../Makefile  get-modeling-dependencies-version))
	@echo "MODELING_DEPENDENCIES_VERSION=<$(MODELING_DEPENDENCIES_VERSION)>"

	$(eval ID = $(shell echo ${ACTIVITI_CLOUD_VERSION}${MODELING_DEPENDENCIES_VERSION}|tr -dc '[:alnum:]\n\r'))
	@echo ID=${ID}	
	
	rm -rf alfresco-process-parent||echo removing alfresco-process-parent
	git clone https://oauth2:${GITLAB_TOKEN}@git.alfresco.com/process-services/alfresco-process-parent.git
	@echo "Clone for alfresco-process-parent done"

	cd alfresco-process-parent && \
	  git checkout develop && \
	  git checkout -b update-cloud-to-$(ACTIVITI_CLOUD_VERSION)-$(MODELING_DEPENDENCIES_VERSION) && \
	  mvn versions:set-property -Dproperty=activiti-cloud.version -DnewVersion=$(ACTIVITI_CLOUD_VERSION) && \
	  mvn versions:set-property -Dproperty=activiti-cloud-modeling.version -DnewVersion=$(MODELING_DEPENDENCIES_VERSION) && \
	  git diff --word-diff && \
	  git commit -a -m "AAE-0 update ACTIVITI_CLOUD_VERSION to ${ACTIVITI_CLOUD_VERSION} MODELING_DEPENDENCIES_VERSION to ${MODELING_DEPENDENCIES_VERSION} ACTIVITI-0000" && \
	  git push  --force --set-upstream origin update-cloud-to-${ACTIVITI_CLOUD_VERSION}-${MODELING_DEPENDENCIES_VERSION} && \
	  curl --request POST --header "PRIVATE-TOKEN: $(GITLAB_TOKEN)" --header "Content-Type: application/json" -d '{"id": ${ID} ,"source_branch": "update-cloud-to-${ACTIVITI_CLOUD_VERSION}-${MODELING_DEPENDENCIES_VERSION}" ,"target_branch":"develop","title":"community propagation ACTIVITI_CLOUD_VERSION to ${ACTIVITI_CLOUD_VERSION} MODELING_DEPENDENCIES_VERSION to ${MODELING_DEPENDENCIES_VERSION}"}' https://git.alfresco.com/api/v4/projects/1031/merge_requests	

build: clean
	helm init --client-only
	helm repo add chartmuseum http://chartmuseum.jx.35.228.195.195.nip.io
	helm repo add activiti-cloud-helm-charts https://activiti.github.io/activiti-cloud-helm-charts/
	helm repo add alfresco https://kubernetes-charts.alfresco.com/stable	
	helm repo add alfresco-incubator https://kubernetes-charts.alfresco.com/incubator
	helm dependency build
	helm lint
	helm upgrade ${HELM_RELEASE_NAME} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--namespace ${PREVIEW_NAMESPACE_LOWERCASE} \
		--debug \
		--wait 	

install: clean build
	helm upgrade ${HELM_RELEASE_NAME} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--namespace ${PREVIEW_NAMESPACE_LOWERCASE} \
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
	   git push --force origin "$(GITHUB_CHARTS_BRANCH)"
	rm -rf $(GITHUB_CHARTS_DIR)

version:
	sed -i -e "s/version:.*/version: $(HELM_ACTIVITI_VERSION)/" Chart.yaml
	sed -i -e "s/tag: .*/tag: $(RELEASE_VERSION)/" values.yaml

tag: version
	git add Chart.yaml values.yaml requirements.yaml
	git commit -m "release $(HELM_ACTIVITI_VERSION)" --allow-empty # if first release then no verion update is performed
	git tag -fa v$(HELM_ACTIVITI_VERSION) -m "Release version $(HELM_ACTIVITI_VERSION)"
	git push origin v$(HELM_ACTIVITI_VERSION)

updatebot/push-version: 	
	cd ../../ && updatebot push-version --kind helm  $(NAME) $(HELM_ACTIVITI_VERSION)

RELEASE_GREP_EXPR := '^[Rr]elease'

git-rev-list:
	$(eval REV = $(shell git rev-list --tags --max-count=1 --grep $(RELEASE_GREP_EXPR)))
	$(eval PREVIOUS_REV = $(shell git rev-list --tags --max-count=1 --skip=1 --grep $(RELEASE_GREP_EXPR)))
	$(eval REV_TAG = $(shell git describe ${PREVIOUS_REV}))
	$(eval PREVIOUS_REV_TAG = $(shell git describe ${REV}))
	@echo Found commits between $(PREVIOUS_REV_TAG) and $(REV_TAG) tags:
	git rev-list $(PREVIOUS_REV)..$(REV) --first-parent --pretty

changelog: git-rev-list
	@echo Creating Github changelog for release: $(HELM_ACTIVITI_VERSION)
	jx step changelog --version v$(HELM_ACTIVITI_VERSION) --generate-yaml=false --rev=$(REV) --previous-rev=$(PREVIOUS_REV)
