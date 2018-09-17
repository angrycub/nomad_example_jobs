job "profile-service" {
  datacenters = ["dc1"]
  group "application" {
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
          "-text", "<html><body><h1>User Profile</h1><hr />This might be a profile page in a while<br />You are on instance ${NOMAD_ALLOC_INDEX} on ${NOMAD_IP_http}.</body></html>",
        ]
      }

      resources {
        memory = 10
        network {
          port "http" {}
        }
      }

      service {
        name = "profile-service"
        tags = ["urlprefix-/profile"]
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

