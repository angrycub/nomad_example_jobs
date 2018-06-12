job "foo-service" {
  datacenters = ["dc1"]
  type = "system"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "2m"
    progress_deadline = "5m"
    canary = 1
  }
  group "example" {
    ephemeral_disk {
       size = "110"
    }

    task "server" {
      artifact {
        source = "https://github.com/hashicorp/http-echo/releases/download/v0.2.3/http-echo_0.2.3_linux_amd64.tar.gz" 
      }
      driver = "exec"

      config {
        command = "http-echo"
        args = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "<html><body><h1>Welcome to the Foo Service.</h1><hr />You are on ${NOMAD_IP_http}.</body></html>",
        ]
      }

      resources {
        network {
          port "http" {}
        }
      }

      service {
        name = "foo-service"
        tags = ["urlprefix-/foo"]
        canary_tags = ["urlprefix-/cfoo"]
        port = "http"
        check {
          type = "http"
          name = "health-check"
          interval = "15s"
          timeout = "5s"
          path = "/"
        }
      }
    }
  }
}

