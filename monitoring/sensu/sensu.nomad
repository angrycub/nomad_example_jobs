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
    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    network {
      port  "web_ui"{
        to = 3000
      }

      port  "api" {
        to = 8080
      }

      port  "ws_api"{
        to = 8081
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

    task "sensu-docker" {
      driver = "docker"

      config {
        image   = "sensu/sensu:latest"
        command = "sensu-backend"
        args    = [
          "start",
          "--state-dir",
          "/var/lib/sensu/sensu-backend",
          "--log-level",
          "debug",
        ]
        ports   = ["web_ui","api","ws_api"]
      }

      env {
        SENSU_BACKEND_CLUSTER_ADMIN_USERNAME = "sensu_admin"
        SENSU_BACKEND_CLUSTER_ADMIN_PASSWORD = "password"
      }
    }
  }
}
