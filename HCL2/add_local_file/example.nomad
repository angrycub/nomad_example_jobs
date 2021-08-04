variable "redis_config_file" {
  type = string
  description = "local path to the redis configuration to inject into the job."
}

job "example" {
  region = "global"
  datacenters = ["dc1"]
  type = "service"
  group "services" {
    count = 1
    network {
      mode = "host"
      port "redis" {
        static = 6379
      }
    }
    task "redis" {
      driver = "docker"

      template {
        destination = "local/redis.conf"
        data = file(var.redis_config_file)
      }

      volume_mount {
        volume      = "redis-data"
        destination = "/data"
        read_only   = false
      }

      config {
        image      = "redis:6.2.1-alpine3.13"
        ports      = ["redis"]
        force_pull = false
        args = [
          "redis-server",
          "/redis.conf",
        ]
        mounts = [
          {
            type   = "bind"
            source = "local/redis.conf"
            target = "/redis.conf"
          },
        ]
      }
    }
  }
}
