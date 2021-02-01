job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    service {
      tags = ["redis", "cache"]
      port = "db"

      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "redis" {
      template {
        data = <<EOH
REDIS_VERSION="{{ keyOrDefault "service/redis/version" "latest" }}"
EOH

        destination = "secrets/file.env"
        env         = true
      }

      driver = "docker"

      config {
        image = "redis:${REDIS_VERSION}"
        ports = ["db"]
      }
    }
  }
}
