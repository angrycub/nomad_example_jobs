job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis2" {
      driver = "docker"

      config {
        image = "redis:3.2"
        volumes = ["../alloc:/allocation"]
        port_map {
          db = 6379
        }
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          port "db" {}
        }
      }
    }
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
	volumes = ["../alloc:/allocation"]
        port_map {
          db = 6379
        }
      }

      resources {
        cpu    = 100
        memory = 128

        network {
          port "db" {}
        }
      }
    }
  }
}
