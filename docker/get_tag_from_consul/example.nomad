job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      driver = "docker"
      config {
        image = "redis:{{key \"test/redis/docker-tag\"}}"
        port_map {
          db = 6379
        }
      }
      resources { network { port "db" {} } }
    }
  }
}
