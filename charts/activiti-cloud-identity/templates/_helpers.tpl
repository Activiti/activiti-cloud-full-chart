{{- define "activiti-cloud-identity.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "activiti-cloud-identity.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "activiti-cloud-identity.keycloak-host" -}}
{{- $value := default (include "common.gateway-host" .) .Values.global.keycloak.host -}}
{{- tpl (printf "%s" $value) . -}}
{{- end -}}

{{- define "activiti-cloud-identity.keycloak-url" -}}
{{ template "common.gateway-proto" . }}://{{ template "activiti-cloud-identity.keycloak-host" . }}{{ template "common.keycloak-path" . }}
{{- end -}}
