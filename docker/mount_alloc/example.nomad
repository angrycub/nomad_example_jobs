job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port db {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image   = "redis:7"
        volumes = ["../alloc:/allocation"]
        ports   = ["db"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
