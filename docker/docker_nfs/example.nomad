job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }
    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
        mounts = [
          {
            type   = "volume"
            target = "/mnt/nfs"
            source = "myRedisNFS"
            volume_options = {
              no_copy = false
              driver_config = {
                name = "local"
                options = {
                  type   = "nfs"
                  device = ":/nfs"
                  o      = "addr=10.0.2.41,vers=4"
                }
              }
            }
          }
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
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
