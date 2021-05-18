job "parameter" { datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "command" {
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "cat local/template.out"]
      }
      template {
        data = <<EOH
{{ range $index, $instance := service "consul"}}
{{ printf "--- %v ---" $index }}
{{ printf "%#v" (toJSONPretty $instance) }}
{{ end }}
  EOH

        destination = "local/template.out"
      }
    }
  }
}
