job "foo-service" {
  datacenters = ["dc1"]
  meta {
    foo-service = "true"
  }
  group "example" {
    count = 3

    task "server" {
      driver = "exec"

      config {
        command ="usr/sbin/http-echo"
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
        tags = ["urlprefix-/foo2"]
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

