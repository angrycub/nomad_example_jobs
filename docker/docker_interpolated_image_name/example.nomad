job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"
      env {
        "REDIS_VERSION" = "3.2"
      }
      config {
        image = "redis:${REDIS_VERSION}"
        port_map {
          db = 6379
        }
      }

      resources {
        network {
          port "db" {}
        }
      }

      service {
        tags = ["redis","cache"]
        port = "db"
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
