NAME := activiti-cloud-full-example
OS := $(shell uname)
VERSION := $(or $(VERSION), $(shell cat ../../VERSION))
PREVIEW_NAMESPACE_LOWERCASE := $(shell echo ${PREVIEW_NAMESPACE}| tr "[:upper:]" "[:lower:]")

GITHUB_CHARTS_REPO := $(or $(GITHUB_CHARTS_REPO),$(shell git config --get remote.origin.url))
GITHUB_CHARTS_BRANCH := $(or $(GITHUB_CHARTS_BRANCH),gh-pages)

GITHUB_CHARTS_DIR := activiti-cloud-helm-charts
	
build: clean
	helm dep up
	helm lint
	helm upgrade ${PREVIEW_NAMESPACE_LOWERCASE} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--namespace ${PREVIEW_NAMESPACE_LOWERCASE} \
		--wait 	\
		--dry-run

install: clean build
	helm upgrade ${PREVIEW_NAMESPACE_LOWERCASE} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--namespace ${PREVIEW_NAMESPACE_LOWERCASE} \
		--debug \
		--wait 

upgrade: clean build
	helm upgrade ${PREVIEW_NAMESPACE_LOWERCASE} .

delete:
	helm delete ${PREVIEW_NAMESPACE_LOWERCASE}

clean:
	rm -rf requirements.lock
	rm -rf charts
	rm -rf ${NAME}*.tgz

release: build
	helm package .

github:
	git clone -b "$(GITHUB_CHARTS_BRANCH)" https://${GITHUB_TOKEN}@github.com/Activiti/activiti-cloud-helm-charts.git $(GITHUB_CHARTS_DIR)
	mkdir $(GITHUB_CHARTS_DIR)/new-charts
	cp "$(NAME)-$(VERSION).tgz" $(GITHUB_CHARTS_DIR)/new-charts
	cd $(GITHUB_CHARTS_DIR) && \
	   helm repo index new-charts --merge index.yaml && \
	   cp new-charts/* . && \
	   rm -fr new-charts && \
	   git add . && \
	   git status && \
	   git commit -m "fix:(version) release $(NAME)-$(VERSION).tgz" && \
	   git pull && \
	   git push -f -q https://${GITHUB_TOKEN}@github.com/Activiti/activiti-cloud-helm-charts.git "$(GITHUB_CHARTS_BRANCH)"
	rm -rf $(GITHUB_CHARTS_DIR)

version:
	yq write --inplace Chart.yaml 'version' $(VERSION)

tag:
	git add Chart.yaml requirements.yaml
	git commit -m "release $(VERSION)" --allow-empty # if first release then no version update is performed
	git tag -fa v$(VERSION) -m "Release version $(VERSION)"
	git push -f -q https://${GITHUB_TOKEN}@github.com/Activiti/activiti-cloud-full-chart.git v$(VERSION)	

updatebot/push-version: 	
	cd ../../ && updatebot push-version --kind helm  $(NAME) $(VERSION)

update-docker-images:
	yq write --inplace values.yaml 'activiti-cloud-modeling.image.tag' $(BACKEND_VERSION)
	yq write --inplace values.yaml 'activiti-modeling-app.image.tag' $(FRONTEND_VERSION)
	yq write --inplace values.yaml 'runtime-bundle.image.tag' $(BACKEND_VERSION)
	yq write --inplace values.yaml 'activiti-cloud-query.image.tag' $(BACKEND_VERSION)
	yq write --inplace values.yaml 'activiti-cloud-connector.image.tag' $(BACKEND_VERSION)
