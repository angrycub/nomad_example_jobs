job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
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
        image   = "pkane/train-os:latest"
        command = "stress"
        args    = ["-v", "--cpu", "2", "--io", "1", "--vm", "2", "--vm-bytes", "128M", "--timeout", "480s"]
        ports   = ["db"]

        cpu_hard_limit = true
      }

      resources {
        cpu    = 50
        memory = 256
      }
    }
  }
}
