
job "sticky" {
  datacenters = ["dc1"]

  update {
    stagger = "10s"
    max_parallel = 1
  }

  group "cache" {
    count = 6

    network {
      port "db" {
        to = 6378
      }
    }

    ephemeral_disk {
      sticky = true
      migrate = true
      size = 3000
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

    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
