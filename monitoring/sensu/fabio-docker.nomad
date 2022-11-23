job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  update {
    stagger      = "5s"
    max_parallel = 1
  }

  group "fabio" {
    network {
      port "proxy" {
        static = 9999
        to     = 9999
      }

      port "ui" {
        static = 9998
        to     = 9998
      }
    }

    task "fabio-docker" {
      driver = "docker"

      config {
        image        = "fabiolb/fabio:latest"
        network_mode = "host"
        ports        = ["proxy","ui"]
      }

      env {
       # FABIO_registry_consul_addr="${attr.unique.network.ip-address}:8500"
      }

      resources {
        cpu    = 200
        memory = 32
      }
    }
  }
}
