{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mailhog.name" -}}
{{- printf "%s-%s" "smtp" (default .Chart.Name .Values.smtp.nameOverride | trunc 58 | trimSuffix "-") -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mailhog.fullname" -}}
{{- if .Values.smtp.fullnameOverride -}}
{{- printf "%s-%s" "smtp" (.Values.smtp.fullnameOverride | trunc 58 | trimSuffix "-") -}}
{{- else -}}
{{- $name := printf "%s-%s" "smtp" (default .Chart.Name .Values.smtp.nameOverride) -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mailhog.chart" -}}
{{- printf "%s-%s-%s" "smtp" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "mailhog.labels" -}}
helm.sh/chart: {{ include "mailhog.chart" . }}
{{ include "mailhog.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.smtp.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mailhog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mailhog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mailhog.serviceAccountName" -}}
{{- if .Values.smtp.serviceAccount.create }}
{{- default (include "mailhog.fullname" .) .Values.smtp.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.smtp.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name for the auth secret.
*/}}
{{- define "mailhog.authFileSecret" -}}
    {{- if .Values.smtp.auth.existingSecret -}}
        {{- .Values.smtp.auth.existingSecret -}}
    {{- else -}}
        {{- template "mailhog.fullname" . -}}-auth
    {{- end -}}
{{- end -}}

{{/*
Create the name for the outgoing-smtp secret.
*/}}
{{- define "mailhog.outgoingSMTPSecret" -}}
    {{- if .Values.smtp.outgoingSMTP.existingSecret -}}
        {{- .Values.smtp.outgoingSMTP.existingSecret -}}
    {{- else -}}
        {{- template "mailhog.fullname" . -}}-outgoing-smtp
    {{- end -}}
{{- end -}}
