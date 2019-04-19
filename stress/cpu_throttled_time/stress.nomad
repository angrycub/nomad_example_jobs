job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        cpu_hard_limit = true
        image = "pkane/train-os:latest"
        command = "stress"
        args = [
          "-v","--cpu","2","--io", "1", "--vm", "2", "--vm-bytes", "128M", "--timeout", "480s"
        ]
        port_map {
          db = 6379
        }
      }

      resources {
        cpu    = 50
        memory = 256
        network {
          mbits = 10
          port "db" {}
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
