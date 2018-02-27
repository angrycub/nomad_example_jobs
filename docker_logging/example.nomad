job "example" {
  datacenters = ["dc1"]
  type = "service"
  group "cache" {
    count = 1
    task "redis" {
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map {
          db = 6379
        }
        logging {
          type = "journald"
          config {
            tag = "docker-example"
          }
        }
      }
      resources {
        network {
          port "db" {}
        }
      }
      service {
        name = "global-redis-check"
        tags = ["global", "cache"]
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
