job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        port_map { db = 6379 }
        mounts = [
          {
            target = "/mnt/nfs"
            source = "myRedisNFS"
            volume_options {
              no_copy = false
              driver_config {
                name = "local"
                options = {
                  type = "nfs"
                  device = ":/nfs"
                  o = "addr=10.0.2.41,vers=4"
                }
              }
            }
          }
        ]
      }

      resources { network { port "db" {} } }

      service {
        port = "db"
        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }
    }
  }
}
