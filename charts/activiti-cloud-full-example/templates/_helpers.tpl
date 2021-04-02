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

