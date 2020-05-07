job "sensu" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "3m"
    progress_deadline = "10m"
    auto_revert       = false
    canary            = 0
  }

  migrate {
    max_parallel     = 1
    health_check     = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "sensu-backend" {
    count = 1

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    ephemeral_disk {
      size = 300
    }

    task "sensu-docker" {
      driver = "docker"

      env {
        "SENSU_BACKEND_CLUSTER_ADMIN_USERNAME" = "sensu_admin"
        "SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD" = "password"
      }

      config {
        image   = "sensu/sensu:latest"
        command = "sensu-backend"

        args = [
          "start",
          "--state-dir",
          "/var/lib/sensu/sensu-backend",
          "--log-level",
          "debug",
        ]

        port_map {
          web_ui = 3000
          api    = 8080
          ws_api = 8081
        }
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10
          port  "web_ui"{}
          port  "api" {}
          port  "ws_api"{}
        }
      }

      service {
        name = "sensu"
        tags = ["ui", "urlprefix-/sensu strip=/sensu"]
        port = "web_ui"

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
