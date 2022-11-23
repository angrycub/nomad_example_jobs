job "demo-webapp" {
  datacenters = ["dc1"]

  group "demo" {
    count = 3

    network {
      port "http" {}
    }

    service {
      name = "demo-webapp"
      port = "http"
      tags = [
        "charlie.enable=true",
        "charlie.http.routers.http.rule=Path(`/myapp`)",
      ]

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/demo-webapp-lb-guide"
      }

      env {
        PORT    = "${NOMAD_PORT_http}"
        NODE_IP = "${NOMAD_IP_http}"
      }
    }
  }
}
