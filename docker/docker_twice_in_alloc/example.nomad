job "example" {
  datacenters = ["dc1"]
  group "cache" {
    network {
      port "db1" {}
      port "db2" {}
    }
    task "redis1" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["db1"]
      }
      resources {
        cpu    = 100
        memory = 128
      }
      service {
        name = "redis-cache-1"
        tags = ["global", "cache"]
        port = "db1"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
    task "redis2" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["db2"]
      }
      resources {
        cpu    = 100
        memory = 128
      }
      service {
        name = "redis-cache-2"
        tags = ["global", "cache"]
        port = "db2"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
