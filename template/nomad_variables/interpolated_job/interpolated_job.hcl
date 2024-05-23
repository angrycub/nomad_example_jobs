job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    // service {
    //   tags = ["redis", "cache"]
    //   port = "db"

    //   check {
    //     name     = "alive"
    //     type     = "tcp"
    //     interval = "10s"
    //     timeout  = "2s"
    //   }
    // }
    task "redis" {
      template {
        data = <<EOH
{{- with nomadVar "nomad/jobs/example" -}}
REDIS_IMAGE="{{.image}}"
REDIS_VERSION="{{.version}}"
{{ end -}}
EOH

        destination = "secrets/file.env"
        env         = true
        change_mode = "restart"
      }

      driver = "docker"

      config {
        image = "${REDIS_IMAGE}:${REDIS_VERSION}"
        ports = ["db"]
      }
    }
  }
}
