
job "super-big" {
  datacenters = ["dc1"]

  update {
    stagger      = "10s"
    max_parallel = 1
  }

  group "cache" {
    count = 6

    network {
      port "db" {}
    }

    service {
      name = "sticky-redis"
      tags = ["global", "sticky", "redis", "cache"]
      port = "db"
      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }


    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    ephemeral_disk {
      sticky  = true
      migrate = true
      size    = 3000
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
