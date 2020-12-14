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

**WARNING** All the PVCs are not deleted by `helm uninstall` and that should be manually unless you want to keep data for another install.

```shell
kubectl get pvc
kubectl delete pvc data-keycloak-...
```

As an alternative, generate a Kubernetes descriptor you can analyse or apply offline using `kubectl apply -f output.yaml`:
```shell
helm template -f values.yaml activiti charts/activiti-cloud-full-example > output.yaml
```

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
