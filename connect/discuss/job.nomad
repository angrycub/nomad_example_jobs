variable "config_data" {
  type        = string
  description = "Plain text config file for blocky"
  default     = "./blocky.yaml"
}

job "blocky" {
  datacenters = ["dc1"]
  type        = "system"
  priority    = 100

  update {
    max_parallel = 1
    auto_revert  = true
  }

  group "blocky" {

    network {
      mode = "bridge"

      port "dns" {
        static = "53"
      }

      port "api" {
        # host_network = "loopback"
        to = "4000"
      }
    }

    service {
      name = "blocky-dns"
      port = "dns"
    }

    service {
      name = "blocky-api"
      port = "api"

      meta {
        metrics_addr = "${NOMAD_ADDR_api}"
      }

      tags = [
        "traefik.enable=true",
      ]

      connect {
        sidecar_service {
          proxy {
            local_service_port = 400

            expose {
              path {
                path            = "/metrics"
                protocol        = "http"
                local_path_port = 4000
                listener_port   = "api"
              }
            }

            upstreams {
              destination_name = "redis"
              local_bind_port  = 6379
            }
          }
        }

        sidecar_task {
          resources {
            cpu        = 50
            memory     = 20
            memory_max = 50
          }
        }
      }

      check {
        name     = "api-health"
        port     = "api"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "3s"
      }
    }

    task "blocky" {
      driver = "docker"

      config {
        image = "ghcr.io/0xerr0r/blocky"
        ports = ["dns", "api"]

        mount {
          type   = "bind"
          target = "/app/config.yml"
          source = "app/config.yml"
        }
      }

      resources {
        cpu        = 50
        memory     = 50
        memory_max = 100
      }

      template {
        data        = file(var.config_data)
        destination = "app/config.yml"
        splay       = "1m"
      }
    }
  }
}