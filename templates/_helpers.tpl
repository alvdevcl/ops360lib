{{/* Generate the nginx-proxy side-car container */}}
{{- define "ops360lib.volumeMounts.tpl" }}
  volumeMounts:
    {{- range $path, $_ := (.Files.Glob "config/*") }}
    - name: config-volume
      mountPath: {{ printf "%s/%s" $.Values.serviceConfigPath (base $path) }}
      subPath: {{ base $path }}
    {{- end }}
    {{- if .Values.keystoreEnabled }}
    - name: keystore-volume
      mountPath: {{ printf "%s/%s" $.Values.serviceConfigPath "keystore.jks" }}
      subPath: keystore.jks
    {{- end }}
{{- end }}

{{- define "ops360lib.volumes.tpl" }}
  volumes:
    - name: config-volume
      configMap:
        name: {{ .Chart.Name }}
        items:
          {{- range $path, $_ := (.Files.Glob "config/*") }}
          - key: {{ base $path }}
            path: {{ base $path }}
          {{- end }}
    {{- if .Values.keystoreEnabled }}
    - name: keystore-volume
      secret:
        secretName: {{ .Values.secretName }}
        items:
          - key: KEYSTORE_FILE
            path: keystore.jks
    {{- end }}
{{- end }}

{{- define "ops360lib.env.tpl" }}
{{- include "ops360lib.envSecrets.tpl" . }}
{{- end }}