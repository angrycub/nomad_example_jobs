job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      template {
        data = <<EOH
file data here
EOH
        destination = "local/config.yml"
        change_mode = "noop"
      }
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
        mounts = [
          {
            type = "bind"
            target = "/root/config.yml"
            source = "local/config.yml"
            readonly = false
            volume_options {
              no_copy = false
            }
          }
        ]
      }
      resources { network { port "db" {} } }
    }
  }
}

