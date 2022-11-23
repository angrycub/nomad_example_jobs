job "template" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1
    network {
      port "http" {}
    }
    task "template" {
      driver = "raw_exec"
      config {
        command = "python"
        args = ["-m", "http.server", "--bind ${NOMAD_IP_http}", "${NOMAD_PORT_http}" ]
      }
      template {
        data = <<EOH
{{ with nomadVar "test/multiregion"}}{{ range $k, $v := .}}
{{- printf "%q=%q" $k $v}}
{{ end }}{{ end }}
EOH
        destination = "template.out"
        change_mode = "restart"
      }
    }
  }
}
