job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"

        port_map {
          dynamic = 6379
          _443    = 6379

          # because 444 can be processed as a number, it needs to be quoted so it is properly
          # handled as a string.
          "444" = 6379
        }
      }

      resources {
        network {
          # the label for the `port` block is used to refer to that port in the rest of the job:
          # interpolation, docker port maps, etc.
          port "dynamic" {}

          port "_443" {
            static = 443
          }

          port "444" {
            static = 444
          }
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
    }
  }
}
