{{/* Validate values of Activiti Cloud - Messaging System */}}
{{- define "activiti-cloud.validateValues.messagingSystem" -}}
{{- if and (or .Values.kafka.enabled .Values.externalKafka.enabled) .Values.rabbitmq.enabled -}}
Activiti Cloud: Messaging System
    You can only use one messaging system.
    Please enable only RabbitMQ or Kafka as messaging system.
{{- else if and .Values.kafka.enabled .Values.externalKafka.enabled -}}
Activiti Cloud: Messaging System
    You can only have one Kafka configuration enabled.
    Please ensure only one of the following parameters is set to 'true'
      - kafka.enabled
      - externalKafka.enabled
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the kafka requirement.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.kafka.fullname" -}}
{{- if contains "kafka" .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "kafka" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the kafka requirement.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common.rabbitmq.fullname" -}}
{{- if contains "rabbitmq" .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "rabbitmq" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
