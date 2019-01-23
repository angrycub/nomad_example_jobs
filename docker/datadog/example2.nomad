job "example" {
  type = "system"
  datacenters = ["dc1"]
  group "monitoring" {
    task "dd-agent" {
      driver = "docker"
      env {
        HOSTIP="${attr.unique.network.ip-address}",
        STATSD_PORT="8125"
        API_KEY = "23cecf6a16b072151c561fe7e6e3938a"
        DD_DOGSTATSD_NON_LOCAL_TRAFFIC = "true"
      }
      config {
        hostname = "${node.unique.name}-docker"
        image = "datadog/docker-dd-agent:latest"
        port_map {
          tport = 8125 
        }
      }
      resources {
        cpu    = 500
        memory = 256
        network {
          mbits = 10
          port "tport" { static = 8125 }
        }
      }
      service {
        name = "datadog"
        tags = ["cache"]
        port = "tport"
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
