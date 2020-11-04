job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        mac_address = "A0:97:FA:13:93:03"
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
