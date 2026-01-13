job "system" {
  datacenters = ["dc1"]
  type        = "system"

  group "statsd" {
    count = 1

    network {
      port "statsd" {
        static = 8125
      }
      port "http" {
        static = 80
      }
      port "admin" {
        static = 9998
      }
    }

    task "statsd" {
      driver = "docker"

      env {
        DD_API_KEY                     = "da0840ea1581e9f5c400918e67d3fa83"
        DD_DOGSTATSD_NON_LOCAL_TRAFFIC = "true"
      }

      config {
        image = "datadog/agent:latest"

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro",
          "/proc/:/host/proc/:ro",
          "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro"
        ]

        ports = ["statsd"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }

    task "fabio" {
      driver = "docker"

      env = {
        "registry.consul.addr" = "${NOMAD_IP_http}:8500"
      }

      config {
        image = "fabiolb/fabio"
        ports = ["http", "admin"]
      }

      resources {
        cpu    = 500
        memory = 256
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
