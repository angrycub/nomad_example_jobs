job "template" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    count = 1

    task "command" {
      driver = "raw_exec"

      template {
        data = <<EOH
{{- define "custom" }}{{ key "template/test" }}{{ end -}}
{{ executeTemplate "custom" }}
EOH

        destination = "local/template.out"
      }

      config {
        command = "bash"
        args    = ["-c", "cat local/template.out"]
      }
    }
  }
}
