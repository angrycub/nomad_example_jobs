job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  update {
    stagger      = "5s"
    max_parallel = 1
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
      tags = ["fabio", "lb"]
      port = "ui"

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

      env {
        registry_consul_addr = "${attr.unique.network.ip-address}:8500"
       # registry_consul_token = "«add if you have a consul enabled cluster»"
      }

      driver = "exec"

      config { 
        command = "fabio-1.5.15-go1.15.5-linux_amd64"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.15/fabio-1.5.15-go1.15.5-linux_amd64"

        options {
          checksum = "sha256:14c7a02ca95fb00a4f3010eab4e3c0e354a3f4953d2a793cb800332012f42066"
        }
      }

      resources {
        cpu    = 200
        memory = 150 
      }
    }
  }
}

