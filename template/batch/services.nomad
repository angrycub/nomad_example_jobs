job "parameter" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    task "command" {
      driver = "exec"

      config {
        command = "bash"
        args    = ["-c", "cat local/template.out"]
      }

      template {
        destination = "local/template.out"
        data        = <<EOH
{{ range $index, $instance := service "consul"}}
{{ printf "--- %v ---" $index }}
{{ printf "%#v" (toJSONPretty $instance) }}
{{ end }}
  EOH
      }
    }
  }
}
