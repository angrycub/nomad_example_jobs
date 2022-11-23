job "example" {
  datacenters = ["dc1"]

  constraint {
    distinct_hosts = true
  }

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
        ports = ["db"]
      }
    }
  }
}
