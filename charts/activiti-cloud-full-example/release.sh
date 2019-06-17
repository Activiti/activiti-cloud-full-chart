#!/bin/bash

export HELM_VERSION=7.1.0-M2
export APP_VERSION=7.1.0.M2
export GITHUB_CHARTS_REPO="https://github.com/Activiti/activiti-cloud-helm-charts.git"


make printrelease
sed -i -e "s/#tag: .*/tag: $APP_VERSION/" values.yaml
make tag
make release
make github
