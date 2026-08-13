{{/*
Expand the name of the chart.
*/}}
{{- define "terminus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "terminus.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "terminus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "terminus.labels" -}}
helm.sh/chart: {{ include "terminus.chart" . }}
{{ include "terminus.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "terminus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "terminus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name
*/}}
{{- define "terminus.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "terminus.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Connection URLs. A bundled service wins over the corresponding secrets.* value,
which is documented as ignored in that case.
*/}}
{{- define "terminus.databaseUrl" -}}
{{- if .Values.database.enabled -}}
{{- $a := .Values.database.auth -}}
{{- printf "postgres://%s:%s@%s-database:%v/%s" $a.username $a.password (include "terminus.fullname" .) .Values.database.port $a.database -}}
{{- else -}}
{{- .Values.secrets.databaseUrl -}}
{{- end -}}
{{- end }}

{{- define "terminus.keyvalueUrl" -}}
{{- if .Values.keyvalue.enabled -}}
{{- $pass := .Values.keyvalue.auth.password -}}
{{- printf "redis://%s%s-keyvalue:%v/%s" (ternary (printf ":%s@" $pass) "" (ne $pass "")) (include "terminus.fullname" .) .Values.keyvalue.port .Values.keyvalue.database -}}
{{- else -}}
{{- .Values.secrets.keyvalueUrl -}}
{{- end -}}
{{- end }}

{{/*
Render a map as annotations or labels.

Values are quoted rather than passed through toYaml: the API server requires
string values, and toYaml would emit an unquoted true/false or a bare number
for anything the values file did not already quote.
*/}}
{{- define "terminus.stringMap" -}}
{{- range $key, $value := . }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Validate mutually exclusive values
*/}}
{{- define "terminus.validateValues" -}}
{{- if and .Values.ingress.enabled .Values.route.enabled }}
{{- fail "ingress.enabled and route.enabled are mutually exclusive; enable only one." }}
{{- end }}
{{- if and .Values.migrate.enabled .Values.vault.enabled (not .Values.vault.migrateInject) (not .Values.migrate.databaseUrl) }}
{{- fail "migrate.databaseUrl is required when vault.enabled and migrate.enabled; the migration job runs without the Vault Agent. Set vault.migrateInject to read it from Vault instead." }}
{{- end }}
{{- if not .Values.config.apiUri }}
{{- fail "config.apiUri is required; Hanami constrains api_uri to be non-empty and it has no default." }}
{{- end }}
{{/*
Empty env vars override the application defaults rather than falling back to
them, so an unset secret surfaces as a settings validation crash at boot.
*/}}
{{- if and .Values.vault.enabled (or .Values.database.enabled .Values.keyvalue.enabled) }}
{{- fail "database.enabled and keyvalue.enabled cannot be combined with vault.enabled; Vault supplies the connection URLs, so a bundled service has nothing to provide them to." }}
{{- end }}
{{- if and .Values.database.enabled .Values.migrate.enabled }}
{{- fail "database.enabled requires migrate.enabled=false; the migration job is a pre-install hook and runs before the bundled database exists. Migrations run at pod startup instead via config.appSetup." }}
{{- end }}
{{- if and .Values.database.enabled (not .Values.database.auth.password) }}
{{- fail "database.auth.password is required when database.enabled." }}
{{- end }}
{{- if not .Values.vault.enabled }}
{{- if not (include "terminus.databaseUrl" .) }}
{{- fail "secrets.databaseUrl is required when vault.enabled is false and database.enabled is false." }}
{{- end }}
{{- if not (include "terminus.keyvalueUrl" .) }}
{{- fail "secrets.keyvalueUrl is required when vault.enabled is false and keyvalue.enabled is false." }}
{{- end }}
{{- if lt (len .Values.secrets.appSecret) 64 }}
{{- fail "secrets.appSecret is required when vault.enabled is false and must be at least 64 characters (try: openssl rand -hex 64)." }}
{{- end }}
{{- end }}
{{- end }}
