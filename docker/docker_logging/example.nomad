job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image          = "redis:7"
        ports          = ["db"]
        auth_soft_fail = true

        logging {
          type = "journald"
          config {
            tag = "docker-example"
          }
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
