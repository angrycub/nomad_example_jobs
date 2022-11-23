job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        network_mode = "myNet"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        network_mode = "myNet"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
