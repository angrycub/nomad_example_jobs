job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      # the label for the `port` block is used to refer to that port in the rest of the job:
      # interpolation, docker port maps, etc.
      port "dynamic" {
        to = 6379
      }

      port "_443" {
        static = 443
        to     = 6379
      }

      port "444" {
        static = 444
        to     = 6379
      }
    }

    service {
      name = "redis-cache"
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
        ports = ["dynamic","_443", "444"]
      }
    }
  }
}
