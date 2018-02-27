job "example" {
  datacenters = ["dc1"]
  type = "service"
  constraint { distinct_hosts = true }
  group "cache" {
    count = 1
    task "redis" {
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map {
          db = 6379
        }
      }
      resources {
        network {
          port "db" {}
        }
      }
    }
  }
}
