job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
      }
    }
  }
}
