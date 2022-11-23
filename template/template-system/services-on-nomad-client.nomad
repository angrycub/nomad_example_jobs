job "template" {
  datacenters = ["dc1"]
  type        = "system"

  group "group" {
    task "template" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = ["-c", "cat local/template.out; while true; do sleep 10; done"]
      }

      template {
        destination = "local/template.out"
        data        = <<EOH

hostname = "{{ env "node.unique.name" }}"

{{- range services -}}
  {{-  if .Name | contains "nomad" -}}
    {{- range service .Name }}
      {{ if (env "node.unique.name") | contains .Node }}
# {{ .Name }}
[[inputs.apache]]
  urls = ["http://{{ .Address }}:{{ .Port }}/server-status?auto"]
  tagexclude = ["host","url"]
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
EOH
      }
      resources {
        memory = 100
        cpu    = 100
      }

    }
  }
}
