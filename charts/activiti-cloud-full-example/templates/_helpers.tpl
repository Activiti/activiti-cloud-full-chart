{{/*
Returns a secret if it already in Kubernetes, otherwise it creates
it randomly.
*/}}
{{- define "getOrGenerateRandomSecret" }}
{{- $len := (default 16 .Length) | int -}}
{{- $obj := (lookup "v1" .Kind .Namespace .Name).data -}}
{{- if $obj }}
{{- index $obj .Key -}}
{{- else if (eq (lower .Kind) "secret") -}}
{{- randAlphaNum $len | b64enc -}}
{{- else -}}
{{- randAlphaNum $len -}}
{{- end -}}
{{- end }}
{{/*
Returns a secret if it already in Kubernetes.
*/}}
{{- define "getKubernetesSecret" }}
{{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
{{- if $obj }}
{{- index $obj .Key | b64dec -}}
{{- else -}}
{{- .Default | default "null" -}}
{{- end -}}
{{- end }}
