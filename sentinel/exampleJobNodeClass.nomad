job "example" {
  datacenters = ["dc1"]

  constraint {
    distinct_hosts = true
  }

  constraint {
    attribute = "${node.class}"
    value    = "gpu"
  }

  group "cache" {
    network {
      port "db" {
        to = 6379
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

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
      }
    }
  }
}
