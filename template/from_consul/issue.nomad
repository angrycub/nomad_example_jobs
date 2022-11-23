job "template" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    task "command" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = ["-c", "cat local/template.out"]
      }

      template {
        destination = "local/template.out"
        data        = <<EOH
{{- define "custom" }}{{ key "template/test" }}{{ end -}}
{{ executeTemplate "custom" }}
EOH
      }
    }
  }
}
