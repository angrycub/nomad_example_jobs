job "template" {
  datacenters = ["dc1"]

  group "group" {
    count = 1

    task "command" {
      template {
        data = <<EOH
{{- with key "template/current" -}}
Name: {{ key (printf "template/%v/name" .) }}
IP: {{ key (printf "template/%v/ip" .) }}:{{ key (printf "template/%v/port" .) }}
{{- printf "\n" -}}
{{- end -}}
EOH
        destination = "local/template.out"
      }

      # This is a favorite do nothing worload.
      driver = "docker"

      config {
        image = "alpine"
        command = "sh"
        args    = ["-c", "while true; do sleep 300; done"]
      }
    }
  }
}
