job "fabio" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "fabio" {
    count = 1
    task "fabio-docker" {
      env {
#        FABIO_registry_consul_addr="${attr.unique.network.ip-address}:8500"
      }
      driver = "docker"
      config {
        image = "fabiolb/fabio:1.5.8-go1.10"
        network_mode = "host"
        port_map {
          proxy = 9999
          ui = 9998
        }      
#        logging {
#          type = "journald"
#          config {}
#        }
      }
      resources {
        cpu = 200
        memory = 32
        network {
          mbits = 1
          port "proxy" { static = "9999" }
          port "ui" { static = "9998" }
        }
      }
    }
  }
}
