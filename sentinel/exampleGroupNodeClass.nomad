job "example" {
  datacenters = ["dc1"]
  type = "service"
  constraint { distinct_hosts = true }
  group "cache" {
    count = 1
     constraint { attribute = "${node.class}" value = "gpu" }
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
  group "cache2" {
    count = 1
    constraint { attribute = "${node.class}" value = "gpu" }
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
