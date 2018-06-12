job "foo-service" {
  datacenters = ["dc1"]
  meta {
    foo-service = "true"
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
          "-text", "<html><body><h1>Welcome to the Foo Service.</h1><hr />You are on ${NOMAD_IP_http}.</body></html>",
        ]
      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "foo-service"
        tags = ["urlprefix-/foo"]
        port = "http"
        check {
          type = "http"
          name = "health-check"
          interval = "15s"
          timeout = "5s"
          path = "/"
        }
      }
      service {
        name = "foo-service-2"
        tags = ["urlprefix-/foo/foo2 strip=/foo"]
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

