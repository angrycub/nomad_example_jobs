job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "command" {
      driver = "raw_exec"
      config {
        command = "bash"
        args = ["-c", "cat local/template.out"]
      }
      template {
        data = <<EOH
{{- define "T1" -}}ONE{{- end -}}
{{- define "T2" -}}{{ key "templates/test" }}{{- end -}}
{{- define "T3" -}}{{- template "T1"}} {{ executeTemplate "T2" . -}}{{- end -}}
{{template "T3"}}
{{env "PATH"}}
EOH

        destination = "local/template.out"
      }
    }
  }
}

#{{- define "custom" }}{{ keyOrDefault "/templates/test" "" }}{{ end -}}
#{{ executeTemplate "custom" }}
