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

Install a recent version of [ingress-nginx](https://kubernetes.github.io/ingress-nginx):

```shell
helm install --repo https://kubernetes.github.io/ingress-nginx ingress-nginx ingress-nginx --version 2.16.0
```

Update all dependencies:
```shell
helm dependency update charts/activiti-cloud-full-example
```
Create Activiti Keycloak Client Kubernetes secret in the `activiti` namespace:

```bash
kubectl create secret generic activiti-keycloak-client \
   --namespace activiti \
   --from-literal=clientId=activiti-keycloak \
   --from-literal=clientSecret=`uuidgen`
```

Create a `values.yaml` file with any customised values from the default [values.yaml](charts/activiti-cloud-full-example/values.yaml) you want, as documented in the chart [README](charts/activiti-cloud-full-example/README.md).

In your local installation to start with, this would be:
```yaml
global:
  gateway:
    host: host.docker.internal
  keycloak:
    host: host.docker.internal
    clientSecretName: activiti-keycloak-client
    useExistingClientSecret: true
```
Alternatively, you can create Activiti Keycloak Client Kubernetes secret with Helm with the following values:

```yaml
global:
  gateway:
    host: host.docker.internal
  keycloak:
    host: host.docker.internal
    clientSecret: changeit
```

In a generic cluster install, you can just add `--set global.gateway.domain=$YOUR_CLUSTER_DOMAIN` to the `helm` command line,
provided your _DNS_ is configured with a wildcard entry `*.$YOUR_CLUSTER_DOMAIN` pointing to your cluster ingress.

Install or upgrade an existing installation:
```shell
helm upgrade --install \
  --atomic --create-namespace --namespace activiti \
  -f values.yaml \
  activiti charts/activiti-cloud-full-example
```

Uninstall:
```shell
helm uninstall --namespace activiti activiti
```

**WARNING** All the PVCs are not deleted by `helm uninstall` and that should be done manually unless you want to keep data for another install.

```shell
kubectl get pvc --namespace activiti
kubectl delete pvc --namespace activiti ...
```
or just delete the namespace fully:
```shell
kubectl delete ns activiti
```

As an alternative, generate a Kubernetes descriptor you can analyse or apply offline using `kubectl apply -f output.yaml`:
```shell
helm template --validate \
  --atomic --create-namespace --dependency-update --namespace activiti \
  -f values.yaml \
  activiti charts/activiti-cloud-full-example
```

## Enabling message partitioning
In order to enable partitioning provide the following [extra values](https://github.com/Activiti/activiti-cloud-full-chart/blob/master/charts/activiti-cloud-full-example/partitioned-values.yaml) (`partitionCount` defines how many partitions will be used and the Helm deployment will create that many replicaSets of query service and configure Rb service with the number of supported partitions in Query):
```yaml
global:
  messaging:
    # global.messaging.partitioned -- enables partitioned messaging in combination with messaging.enabled=true && messaging.role=producer|consumer
    partitioned: true
    # global.messaging.partitionCount -- configures number of partitioned consumers
    partitionCount: 2
```

## Use Kafka instead of Rabbit MQ
In order to switch the message broker to Kafka add the following [extra values](https://github.com/Activiti/activiti-cloud-full-chart/blob/master/charts/activiti-cloud-full-example/kafka-values.yaml)
```yaml
global:
  messaging:
    broker: kafka
kafka:
  enabled: true
rabbitmq:
  enabled: false
```

### Message Partitioning with Kafka
Kafka has an architecture different from RabbitMQ. One Kafka topic can be served by a number of partitions that must be greater or equal to the consumer number.

So using the Kafka broker it is possible to specify a number `partitionCount` greater or equal to the number of `replicaCount` (the consumers). Defining these two number independently allow the user to allocate consumers only if it is needes, avoiding to waste resources.

```yaml
global:
  messaging:
    partitioned: true
    # global.messaging.partitionCount -- set the Kafka partition number
    partitionCount: 4
# replicaCount -- set the Kafka consumer number
replicaCount: 2
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
