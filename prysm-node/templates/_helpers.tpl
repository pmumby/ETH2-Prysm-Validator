{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "prysm-node.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "prysm-node.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
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
{{- define "prysm-node.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "prysm-node.labels" -}}
helm.sh/chart: {{ include "prysm-node.chart" . }}
{{ include "prysm-node.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Beacon labels
*/}}
{{- define "prysm-node.beaconLabels" -}}
helm.sh/chart: {{ include "prysm-node.chart" . }}
{{ include "prysm-node.beaconSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Validator labels
*/}}
{{- define "prysm-node.validatorLabels" -}}
helm.sh/chart: {{ include "prysm-node.chart" . }}
{{ include "prysm-node.validatorSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Prometheus labels
*/}}
{{- define "prysm-node.prometheusLabels" -}}
helm.sh/chart: {{ include "prysm-node.chart" . }}
{{ include "prysm-node.prometheusSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Grafana labels
*/}}
{{- define "prysm-node.grafanaLabels" -}}
helm.sh/chart: {{ include "prysm-node.chart" . }}
{{ include "prysm-node.grafanaSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "prysm-node.selectorLabels" -}}
app.kubernetes.io/name: {{ include "prysm-node.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Selector labels for beacon node
*/}}
{{- define "prysm-node.beaconSelectorLabels" -}}
serviceRole: beacon
{{ include "prysm-node.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels for validator node
*/}}
{{- define "prysm-node.validatorSelectorLabels" -}}
serviceRole: validator
{{ include "prysm-node.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels for prometheus node
*/}}
{{- define "prysm-node.prometheusSelectorLabels" -}}
serviceRole: prometheus
{{ include "prysm-node.selectorLabels" . }}
{{- end -}}

{{/*
Selector labels for grafana node
*/}}
{{- define "prysm-node.grafanaSelectorLabels" -}}
serviceRole: grafana
{{ include "prysm-node.selectorLabels" . }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "prysm-node.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "prysm-node.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
