job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis1" {
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
      }
      resources { network { port "db" {} } }
      service {
        name = "redis-cache"
        tags = ["global", "cache"]
        port = "db"
        check { name="alive" type="tcp" interval="10s" timeout="2s" }
      }
    }
    task "redis2" {
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
      }
      resources { network { port "db" {} } }
      service {
        name = "redis-cache"
        tags = ["global", "cache"]
        port = "db"
        check { name="alive" type="tcp" interval="10s" timeout="2s" }
      }
    }
  }
}

