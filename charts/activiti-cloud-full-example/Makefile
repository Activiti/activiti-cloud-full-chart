NAME := activiti-cloud-full-example
VERSION := $(or ${VERSION}, $(shell cat ../../VERSION))
PREVIEW_NAMESPACE_LOWERCASE := $(shell echo ${PREVIEW_NAME} | tr "[:upper:]" "[:lower:]")
GITHUB_CHARTS_BRANCH := $(or ${GITHUB_CHARTS_BRANCH}, gh-pages)
GITHUB_CHARTS_DIR := activiti-cloud-helm-charts
CLIENT_SECRET := $(or ${CLIENT_SECRET}, dry-run)

build: clean
	helm dep up
	helm lint
	helm upgrade ${PREVIEW_NAMESPACE_LOWERCASE} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--set global.keycloak.clientSecret=${CLIENT_SECRET} \
		--namespace ${PREVIEW_NAMESPACE_LOWERCASE} \
		--wait 	\
		--dry-run

install: clean build
	helm upgrade ${PREVIEW_NAMESPACE_LOWERCASE} . \
		--install \
		--set global.gateway.domain=${GLOBAL_GATEWAY_DOMAIN} \
		--set global.keycloak.clientSecret=${CLIENT_SECRET} \
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
	yq -i e '.version = "$(VERSION)"' Chart.yaml

tag:
	git add -u
	git commit -m "release $(VERSION)" --allow-empty # if first release then no version update is performed
	git tag -fa $(TAG_PREFIX)$(VERSION) -m "Release version $(VERSION)"
	git push -f -q https://${GITHUB_TOKEN}@github.com/Activiti/activiti-cloud-full-chart.git $(TAG_PREFIX)$(VERSION)

update-docker-images:
	yq -i e '.runtime-bundle.image.tag = "$(BACKEND_VERSION)"' values.yaml
	yq -i e '.activiti-cloud-query.image.tag = "$(BACKEND_VERSION)"' values.yaml
	yq -i e '.activiti-cloud-connector.image.tag = "$(BACKEND_VERSION)"' values.yaml
	yq -i e '.activiti-cloud-modeling.image.tag = "$(BACKEND_VERSION)"' values.yaml
	yq -i e '.activiti-modeling-app.image.tag = "$(FRONTEND_VERSION)"' values.yaml
