{{/*
Copyright Broadcom, Inc. All Rights Reserved.
SPDX-License-Identifier: APACHE-2.0
*/}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We need to truncate to 50 characters due to the long names generated for pods
*/}}
{{- define "kube-prometheus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 50 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 26 chars due to the long names generated (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-prometheus.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 26 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 26 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 26 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* Name suffixed with operator */}}
{{- define "kube-prometheus.operator.name" -}}
{{- printf "%s-operator" (include "kube-prometheus.name" .) -}}
{{- end -}}

{{/* Name suffixed with prometheus */}}
{{- define "kube-prometheus.prometheus.name" -}}
{{- printf "%s-prometheus" (include "kube-prometheus.name" .) -}}
{{- end -}}

{{/* Name suffixed with alertmanager */}}
{{- define "kube-prometheus.alertmanager.name" -}}
{{- printf "%s-alertmanager" (include "kube-prometheus.name" .) -}}
{{- end -}}

{{/* Fullname suffixed with operator */}}
{{- define "kube-prometheus.operator.fullname" -}}
{{- printf "%s-operator" (include "kube-prometheus.fullname" .) -}}
{{- end -}}

{{/* Fullname suffixed with prometheus */}}
{{- define "kube-prometheus.prometheus.fullname" -}}
{{- printf "%s-prometheus" (include "kube-prometheus.fullname" .) -}}
{{- end -}}

{{/* Fullname suffixed with alertmanager */}}
{{- define "kube-prometheus.alertmanager.fullname" -}}
{{- printf "%s-alertmanager" (include "kube-prometheus.fullname" .) -}}
{{- end -}}

{{/* Fullname suffixed with blackbox-exporter */}}
{{- define "kube-prometheus.blackboxExporter.fullname" -}}
{{- printf "%s-blackbox-exporter" (include "kube-prometheus.fullname" .) -}}
{{- end -}}

{{/* Fullname suffixed with thanos */}}
{{- define "kube-prometheus.thanos.fullname" -}}
{{- printf "%s-thanos" (include "kube-prometheus.prometheus.fullname" .) -}}
{{- end -}}

{{/* Fullname suffixed with config-reloader */}}
{{- define "kube-prometheus.configReloader.fullname" -}}
{{- printf "%s-config-reloader" (include "kube-prometheus.prometheus.fullname" .) -}}
{{- end -}}

{{/*
Labels for operator
*/}}
{{- define "kube-prometheus.operator.labels" -}}
{{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) }}
app.kubernetes.io/component: operator
app: prometheus
{{- end -}}

{{/*
Labels for prometheus
*/}}
{{- define "kube-prometheus.prometheus.labels" -}}
{{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) }}
app.kubernetes.io/component: prometheus
app: prometheus
{{- end -}}

{{/*
Labels for alertmanager
*/}}
{{- define "kube-prometheus.alertmanager.labels" -}}
{{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) }}
app.kubernetes.io/component: alertmanager
app: prometheus
{{- end -}}

{{/*
Labels for blackbox-exporter
*/}}
{{- define "kube-prometheus.blackboxExporter.labels" -}}
{{- include "common.labels.standard" ( dict "customLabels" .Values.commonLabels "context" $ ) }}
app.kubernetes.io/component: blackbox-exporter
app: prometheus
{{- end -}}

{{/*
Labels for operator pods
*/}}
{{- define "kube-prometheus.operator.podLabels" -}}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.operator.podLabels .Values.commonLabels ) "context" . ) }}
{{- include "common.labels.standard" ( dict "customLabels" $podLabels "context" $ ) }}
app.kubernetes.io/component: operator
app: prometheus
{{- end -}}

{{/*
Labels for blackbox-exporter pods
*/}}
{{- define "kube-prometheus.blackboxExporter.podLabels" -}}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.blackboxExporter.podLabels .Values.commonLabels ) "context" . ) }}
{{- include "common.labels.standard" ( dict "customLabels" $podLabels "context" $ ) }}
app.kubernetes.io/component: blackbox-exporter
app: prometheus
{{- end -}}

{{/*
matchLabels for operator
*/}}
{{- define "kube-prometheus.operator.matchLabels" -}}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.operator.podLabels .Values.commonLabels ) "context" . ) }}
{{- include "common.labels.matchLabels" ( dict "customLabels" $podLabels "context" $ ) }}
app.kubernetes.io/component: operator
app: prometheus
{{- end -}}

{{/*
matchLabels for prometheus
*/}}
{{- define "kube-prometheus.prometheus.matchLabels" -}}
{{- if or .Values.prometheus.podMetadata.labels .Values.commonLabels }}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.prometheus.podMetadata.labels .Values.commonLabels ) "context" . ) }}
{{- include "common.tplvalues.render" ( dict "value" $podLabels "context" $ ) }}
{{- end }}
app.kubernetes.io/name: prometheus
app: prometheus
app.kubernetes.io/component: prometheus
prometheus: {{ template "kube-prometheus.prometheus.fullname" . }}
{{- end -}}

{{/*
matchLabels for alertmanager
*/}}
{{- define "kube-prometheus.alertmanager.matchLabels" -}}
{{- if or .Values.alertmanager.podMetadata.labels .Values.commonLabels }}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.alertmanager.podMetadata.labels .Values.commonLabels ) "context" . ) }}
{{- include "common.tplvalues.render" ( dict "value" $podLabels "context" $ ) }}
{{- end }}
app.kubernetes.io/name: alertmanager
app: prometheus
app.kubernetes.io/component: alertmanager
alertmanager: {{ template "kube-prometheus.alertmanager.fullname" . }}
{{- end -}}

{{/*
matchLabels for blackbox-exporter
*/}}
{{- define "kube-prometheus.blackboxExporter.matchLabels" -}}
{{- $podLabels := include "common.tplvalues.merge" ( dict "values" ( list .Values.blackboxExporter.podLabels .Values.commonLabels ) "context" . ) }}
{{- include "common.labels.matchLabels" ( dict "customLabels" $podLabels "context" $ ) }}
app.kubernetes.io/component: blackbox-exporter
app: prometheus
{{- end -}}

{{/*
Return the proper Prometheus Operator image name
*/}}
{{- define "kube-prometheus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Prometheus Operator Reloader image name
*/}}
{{- define "kube-prometheus.prometheusConfigReloader.image" -}}
{{- if and .Values.operator.prometheusConfigReloader.image.repository .Values.operator.prometheusConfigReloader.image.tag -}}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.prometheusConfigReloader.image "global" .Values.global) -}}
{{- else -}}
{{- include "kube-prometheus.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Prometheus Image name
*/}}
{{- define "kube-prometheus.prometheus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Thanos Image name
*/}}
{{- define "kube-prometheus.prometheus.thanosImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.thanos.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Alertmanager Image name
*/}}
{{- define "kube-prometheus.alertmanager.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.alertmanager.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Blackbox Exporter Image name
*/}}
{{- define "kube-prometheus.blackboxExporter.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.blackboxExporter.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kube-prometheus.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.operator.image .Values.operator.prometheusConfigReloader.image .Values.prometheus.image .Values.prometheus.thanos.image .Values.alertmanager.image .Values.blackboxExporter.image) "context" $) -}}
{{- end -}}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "kube-prometheus.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{- default (include "kube-prometheus.operator.fullname" .) .Values.operator.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.operator.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the blackbox-exporter service account to use
*/}}
{{- define "kube-prometheus.blackboxExporter.serviceAccountName" -}}
{{- if .Values.blackboxExporter.serviceAccount.create -}}
    {{- default (include "kube-prometheus.blackboxExporter.fullname" .) .Values.blackboxExporter.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.blackboxExporter.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the prometheus service account to use
*/}}
{{- define "kube-prometheus.prometheus.serviceAccountName" -}}
{{- if .Values.prometheus.serviceAccount.create -}}
    {{- default (include "kube-prometheus.prometheus.fullname" .) .Values.prometheus.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.prometheus.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the alertmanager service account to use
*/}}
{{- define "kube-prometheus.alertmanager.serviceAccountName" -}}
{{- if .Values.alertmanager.serviceAccount.create -}}
    {{- default (include "kube-prometheus.alertmanager.fullname" .) .Values.alertmanager.serviceAccount.name -}}
{{- else -}}
    {{- default "default" .Values.alertmanager.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Return the etcd configuration configmap
*/}}
{{- define "kube-prometheus.blackboxExporter.configmapName" -}}
{{- if .Values.blackboxExporter.existingConfigMap -}}
    {{- printf "%s" (tpl .Values.blackboxExporter.existingConfigMap $) -}}
{{- else -}}
    {{- include "kube-prometheus.blackboxExporter.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kube-prometheus.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
