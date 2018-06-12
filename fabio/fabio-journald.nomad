job "fabio" {
  datacenters = ["dc1"]
  type = "system"
  group "fabio" {
    count = 1

    task "fabio" {
      driver = "docker"

      logs {
        max_files     = 10
        max_file_size = 10
      }

      config {
        image = "fabiolb/fabio"
        port_map = {
          http = 9999
          admin = 9998
        }
#        logging {
#          driver = "journald"
#        }
        network_mode = "host"
      }

      resources {
        cpu    = 100 # 100 MHz
        memory = 128 # 128 MB
        network {
          mbits = 10
        }
      }

      env {
        registry.consul.addr="${attr.unique.network.ip-address}:8500"
      }
    }
  }
}
