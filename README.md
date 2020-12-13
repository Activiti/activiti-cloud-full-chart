# activiti-cloud-full-chart

[Getting Started Guide](https://activiti.gitbook.io/activiti-7-developers-guide/getting-started/getting-started-activiti-cloud)

More information:
* all chart archives, located at: https://github.com/Activiti/activiti-cloud-helm-charts
* full chart, located at: https://github.com/Activiti/activiti-cloud-full-chart (this repo) 
* a common chart as a base chart for all charts, located at: https://github.com/Activiti/activiti-cloud-common-chart
* charts for components, as sub folders located at: https://github.com/Activiti/activiti-cloud-application

## Running on Docker Desktop

Install [Docker Desktop](https://www.docker.com/products/docker-desktop) and make sure the included single node Kubernetes cluster is started.

Install the latest version of [Helm](https://helm.sh).

Add the magic `host.docker.internal` hostname to your hosts file:

```shell
sudo echo "127.0.0.1        host.docker.internal" > /etc/hosts
```

Install the latest version of [ingress-nginx](https://kubernetes.github.io/ingress-nginx):

```shell
helm install --repo https://kubernetes.github.io/ingress-nginx ingress-nginx ingress-nginx
```

Update all dependencies:
```shell
helm dep up charts/activiti-cloud-full-example
```

Create a `values.yaml` file with any customised values from the default [values.yaml](charts/activiti-cloud-full-example/values.yaml) you want, as documented in the chart [README](charts/activiti-cloud-full-example/README.md). 

In your local installation to start with, this would be:
```yaml
global:
  gateway:
    host: host.docker.internal
  keycloak:
    host: host.docker.internal
```

Install or upgrade an existing installation:
```shell
helm upgrade --install -f values.yaml activiti charts/activiti-cloud-full-example
```

Uninstall:
```shell
helm uninstall activiti
```

As an alternative, generate a Kubernetes descriptor you can analyse or apply offline using `kubectl apply -f output.yaml`:
```shell
helm template -f values.yaml activiti charts/activiti-cloud-full-example > output.yaml
```

## Preview Environments 

**Currently not supported in the Travis CI build.**

This is triggered on any new branch with a name matching the _feature-*_ pattern.
It installs Helm chart from feature branch commit into preview namespace for development and testing.

To create preview environment use the following commands  i.e.

```bash
git checkout <tag or branch>
git checkout -b feature-awesome
git push -u origin feature-awesome

```
or use provided `make preview` command, i.e.

```bash
make preview FROM=<master or tag> FEATURE=awesome

```

After pushing branch to remote, check your branch deployment status on Github: https://github.com/activiti/activiti-cloud-full-chart/branches'

If you make any changes and push the commit to remote, it will trigger preview stage again and upgrade the environment automatically.

To delete preview environment, simply delete your feature-* branch from remote. Once Jenkins runs the clean up, it will trigger another Jenkins pipeline to delete deployed release and namespace in the K8s cluster.

## Skipping CI

If you want to skip running release pipeline stages, simply add `[ci skip]` to your commit message.

## CI/CD

Running on Travis, requires the following environment variable to be set:

| Name | Description |
|------|-------------|
| MAVEN_USERNAME | Internal Maven repository username |
| MAVEN_PASSWORD | Internal Maven repository password |
| GITHUB_TOKEN | Github token for git service account |
| GITHUB_USER | Github user name for git service account |
| K8S_API_TOKEN | Kubernetes API token |
| K8S_API_URL | Kubernetes API url |
