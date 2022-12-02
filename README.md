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
helm install --repo https://kubernetes.github.io/ingress-nginx ingress-nginx ingress-nginx
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
In order to enable partitioning provide the following [extra values](https://github.com/Activiti/activiti-cloud-full-chart/blob/develop/charts/activiti-cloud-full-example/partitioned-values.yaml) (`partitionCount` defines how many partitions will be used and the Helm deployment will create that many replicaSets of query service and configure Rb service with the number of supported partitions in Query):
```yaml
global:
  messaging:
    # global.messaging.partitioned -- enables partitioned messaging in combination with messaging.enabled=true && messaging.role=producer|consumer
    partitioned: true
    # global.messaging.partitionCount -- configures number of partitioned consumers
    partitionCount: 4
```

## Use Kafka instead of Rabbit MQ
In order to switch the message broker to Kafka add the following [extra values](https://github.com/Activiti/activiti-cloud-full-chart/blob/develop/charts/activiti-cloud-full-example/kafka-values.yaml)
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
Kafka has different architecture from RabbitMQ. One Kafka topic can be served by a number of partitions independent from the consumer number (greater or equal).

Configuring the Kafka broker in the helm chart it is possible to specify `partitionCount` greater or equal to the `replicaCount` (the consumer number).
Defining these two number independently allow the user to instantiate consumers only if it is needed, avoiding to waste resources.

```yaml
global:
  messaging:
    partitioned: true
    # global.messaging.partitionCount -- set the Kafka partition number
    partitionCount: 4

activiti-cloud-query:
  # replicaCount -- set the Kafka consumer number
  replicaCount: 2
```

## Enabling HorizontalPodAutoscaler (HPA)

Kubernetes supports horizontal scalability through Horizontal Pod Autoscaler (HPA) mechanism.
In `activiti-cloud-full-charts` it is now possible to enable HPA for the `runtime-bundle` and `activiti-cloud-query` microservices.

### Requirements
The HorizontalPodAutoscaler can fetch metrics from aggregated APIs that, for Kubernetes (metrics.k8s.io), are provided by an add-on named `Metrics Server`.

So, `Metric Server` needs to be installed and launched to use the HPA feature. Please refer to [this page](https://github.com/kubernetes-sigs/metrics-server) for its installation.

### HPA Configuration

In the `activiti-cloud-full-chart` the HorizontalPodAutoscaler is disabled by default for backward compatibility. Please
add the following configuration to your `values.yaml` to enable and use it:

```yaml
runtime-bundle:
  hpa:
    enabled: true
    minReplicas: 1
    maxReplicas: 6
    cpu: 90
    memory: "2000Mi"
activiti-cloud-query:
  hpa:
    enabled: true
    minReplicas: 1
    maxReplicas: 4
    cpu: 90
```

This configuration (present in the `hpa-values.yaml` file in this repository) enable HPA for both `runtime-bundle` and `activiti-cloud-query`.

> :warning: **WARNING**: the provided values are just an example. Please adjust the values to your specific use case.

#### Configuration Properties

| Name                    | Description                               | Default |
|-------------------------|-------------------------------------------|---------|
| `enabled`               | enables the HPA feature                   | `false` |
| `minReplicas`           | starting number of replicas to be spawned |         |
| `maxReplicas`           | max number of replicas to be spawned      |         |
| `cpu`                   | +1 replica over this average % CPU value  |         |
| `memory`                | +1 replica over this average memory value |         |
| `scalingPolicesEnabled` | enables the scaling policies              | `true`  |

### Scaling Polices

Scaling policies allow Kubernetes to stabilize the number of pods when there are swift fluctuations of the load. The scale-down policies are configured so that:

- only 1 pod can be dismissed every minute.
- only 15% of the number of pods can be dismissed every minute.
- the policy that scales down more pods will be triggered first.

The scale-up policies are the default Kubernetes ones.

These policies are always enabled until a `scalingPolicesEnabled: false` is specified in the configuration.

### Activiti Cloud Query and HPA

**Activiti Cloud** supports both `RabbitMQ` and `Kafka` message broker. **Activiti Cloud Query** is a consumer of the message broker, so we need to be extra careful in the configuration of the automatic scalability in order to keep it working properly.

As a general rule, the automatic horizontal scalability for the query consumers should be enabled only when the Activiti Cloud has enabled `partitioning`.

#### Activiti Cloud Query and HPA with Kafka

In a partitioned installation, Kafka allows the consumers to connect to one or more partitions with the maximum ratio of 1:1 between partitions and consumers.

So when configuring HPA please **don't** specify the `maxReplicas` value greater than the `partitionCount`.

#### Activiti Cloud Query and HPA with RabbitMQ

When partitioning RabbitMQ the configuration will spawn one replica for every partition, so you should avoid activating the `HorizontalPodAutoscaler` in this case.

## Skipping CI

If you want to skip running release pipeline stages, simply add `[ci skip]` to your commit message.

## CI/CD

Running on Github Actions, requires the following environment variable to be set:

| Name | Description |
|------|-------------|
| GITHUB_TOKEN | Github token for git service account |
| GITHUB_USER | Github user name for git service account |
| K8S_API_TOKEN | Kubernetes API token |
| K8S_API_URL | Kubernetes API url |
