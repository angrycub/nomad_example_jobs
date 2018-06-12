job "system" {
  datacenters = ["dc1"]

  type = "system"

  group "statsd" {
    count = 1
    
    task "statsd" {
      driver = "docker"

      env {
        DD_API_KEY = "da0840ea1581e9f5c400918e67d3fa83"
        DD_DOGSTATSD_NON_LOCAL_TRAFFIC = "true"
      }

      config {
        image = "datadog/agent:latest"
        
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro",
          "/proc/:/host/proc/:ro",
          "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
        ]

        port_map {
          statsd = 8125
        }
      }

      resources {
        cpu    = 100 # 100 MHz
        memory = 64 # 128MB

        network {
          mbits = 1

          port "statsd" {
            static = 8125
          }
        }
      }
    }

    task "fabio" {
      driver = "docker"
      
      env {
        registry.consul.addr = "${NOMAD_IP_http}:8500"
      }

      config {
        image = "fabiolb/fabio"

        port_map {
          http = 9999
          admin = 9998
        }

      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "admin" {
           static = 9998
          }

          port "http" {
            static = 80
          }
        }
      }

      service {
        port = "admin"
        name = "fabio"
        tags = ["microservice"]

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/health"
        }
      }
    }
  }
}

