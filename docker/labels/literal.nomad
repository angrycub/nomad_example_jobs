job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
        labels = {
          "com.datadoghq.ad.logs" = "[{\"source\": \"nginx\", \"service\": \"webapp\"}]"
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
