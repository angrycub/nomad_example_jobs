job "pne" {
  datacenters = ["dc1"]
  type = "system"
  group "system" {
    task "node-exporter" {
      driver = "raw_exec"

      config {
        command = "local/node_exporter-0.18.1.linux-amd64/node_exporter"
        args = [
          "--web.listen-address=:${NOMAD_PORT_exporter}"
        ]
      }

      artifact {
        source = "https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz"
        destination = "local"
        options { checksum = "sha256:b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424" }
      }

      resources {
        cpu    = 500
        memory = 256
        network {
          mbits = 10
          port "exporter" { static = 9100 }
        }
      }

      service {
        name = "node-exporter"
        tags = []
        port = "exporter"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}