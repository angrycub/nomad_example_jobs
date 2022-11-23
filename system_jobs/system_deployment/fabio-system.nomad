job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  update {
    max_parallel     = 1
    canary           = 1
    min_healthy_time = "30s"
    healthy_deadline = "2m"
    auto_revert      = true
  }

  group "linux-amd64" {
    network {
      port "http" {
        static = 9999
      }
      port "ui" {
        static = 9998
      }
    }

    service {
      tags        = ["fabio", "lb"]
      canary_tags = ["fabio-canary", "lb-canary"]
      port        = "ui"
      check {
        name     = "fabio ui port is alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
      check {
        name     = "fabio health check"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "fabio" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "amd64"
      }
      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "linux"
      }
      driver = "exec"
      config { command = "fabio-1.5.2-go1.8.3-linux_amd64" }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.2/fabio-1.5.2-go1.8.3-linux_amd64"
        #        options {
        #          checksum = "sha256:7dc786c3dfd8c770d20e524629d0d7cd2cf8bb84a1bf98605405800b28705198"
        #        }
      }
      resources {
        cpu    = 200
        memory = 32

      }
    }
  }
}
