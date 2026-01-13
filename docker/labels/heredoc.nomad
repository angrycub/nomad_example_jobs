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
          "com.datadoghq.ad.logs" = <<EOL
            [{
              "source": "atlas",
              "service": "atlas",
              "log_processing_rules": [{
                "type": "exclude_at_match",
                "name": "exclude_healthcheck",
                "pattern": "\"healthcheck\":{\"healthy\":true}"
              }]
            }]
EOL
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
