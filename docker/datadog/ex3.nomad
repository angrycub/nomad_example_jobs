job "example" {
  type        = "system"
  datacenters = ["dc1"]

  group "monitoring" {
    network {
      port "tport" {
        static = 8125
      }
    }

    task "dd-agent" {
      driver = "docker"

      env {
        HOSTIP                         = "${attr.unique.network.ip-address}"
        STATSD_PORT                    = "8125"
        API_KEY                        = "23cecf6a16b072151c561fe7e6e3938a"
        DD_DOGSTATSD_NON_LOCAL_TRAFFIC = "true"
      }

      config {
        hostname     = "${node.unique.name}-docker"
        image        = "datadog/docker-dd-agent:latest"
        network_mode = "host"
        ports        = ["tport"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
