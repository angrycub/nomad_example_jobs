job "car-service" {
  datacenters = ["dc1"]
  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "30s"
    progress_deadline = "2m"
    auto_revert       = false
    stagger           = "30s"
  }
  group "example" {
    count = 3
    task "server" {
      artifact {
        source      = "https://github.com/hashicorp/http-echo/releases/download/v0.2.3/http-echo_0.2.3_linux_amd64.tar.gz" 
        options {
          checksum = "sha256:e30b29b72ad5ec1f6dfc8dee0c2fcd162f47127f2251b99e47b9ae8af1d7b917"
        }
      }
      driver = "exec"

      config {
        command = "http-echo"
        args = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "<html><body><h1>Welcome to the Car Service.</h1><hr />You are on ${NOMAD_IP_http}.</body></html>",
        ]
      }

      resources {
        memory = 10
        network {
          port "http" {}
          port "supernotreal" {}
        }
      }

      service {
        name = "car-service"
        tags = ["urlprefix-/car"]
        port = "supernotreal"
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

