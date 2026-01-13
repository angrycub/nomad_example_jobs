job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }

    task "redis" {
      driver = "docker"

      template {
        destination = "local/env"
        env         = true
        data        = <<EOH
DATADOG_LOG=[{"source": "atlas", "service": "atlas"}]
EOH
      }

      config {
        image = "redis:7"
        ports = ["db"]
        labels = {
          "com.datadoghq.ad.logs" = "${DATADOG_LOG}"
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
