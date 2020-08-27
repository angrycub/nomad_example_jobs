job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      template {
        destination = "secrets/log.env"
        env = true
        data = <<EOF
DATADOG.LOG={{`
            [{
              "source": "atlas",
              "service": "atlas",
              "log_processing_rules": [{
                "type": "exclude_at_match",
                "name": "archivist_sensitive_urls",
                "pattern": "Archivist upload completion callback received"
              }]
            }]
` | parseJSON | toJSON | toJSON }}
EOF
      }
      driver = "docker"

      config {
        image = "redis:3.2"

        port_map {
          db = 6379
        }
	labels {
          com.datadoghq.ad.logs = "${DATADOG.LOG}"
	}
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          mbits = 10
          port "db" {}
        }
      }
    }
  }
}
