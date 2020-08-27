job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        labels {
          "com.datadoghq.ad.logs" ="[{\"source\": \"nginx\", \"service\": \"webapp\"}]"
        }
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
