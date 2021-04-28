job "fabio" {
  datacenters = ["dc1"]
  type = "system"
  group "fabio" {
    task "fabio" {
      driver = "docker"
      env {
        "FABIO_registry_consul_token" = "c8a3dc1b-b772-9451-6547-0d0d3303a9e2"
      }
      config {
        image = "fabiolb/fabio"
        network_mode = "host"
      }
      resources {
        cpu    = 200
        memory = 128
        network {
          mbits = 20
          port "lb" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
