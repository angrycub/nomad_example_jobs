job "fail-service" {
  datacenters = ["dc1"]
  type        = "service"

  reschedule {
    delay          = "15s"
    delay_function = "constant"
    unlimited      = true
  }

  group "api" {
    count = 1

    restart {
      attempts = 3
      interval = "30s"
      delay    = "5s"
      mode     = "fail"
    }

    network {
      mode = "bridge"
      port "http" {
        to = 8080
      }
    }

    service {
      name = "fail-service-nomad"
      port = "http"

      check {
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"

        check_restart {
          limit           = 1
          grace           = "10s"
          ignore_warnings = false
        }
      }
    }

    task "main" {
      driver = "docker"

      config {
        image = "thobe/fail_service:v0.1.0"
        ports = ["http"]
      }

      env = {
        HEALTHY_FOR   = 20
        UNHEALTHY_FOR = 120
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
