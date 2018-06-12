job "example" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
    progress_deadline = "10m"
  }
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }
  group "cache" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    reschedule {
      attempts       = 15
      interval       = "1h"
      delay          = "30s"
      delay_function = "exponential"
      max_delay      = "120s"
      unlimited      = false
    }
    task "redis" {
      driver = "raw_exec"
      config {
        command = "bash"
        args = [
          "-c", "SLEEP_SECS=2; while true; do echo $(date) -- Alive... going back to sleep for ${SLEEP_SECS}; sleep ${SLEEP_SECS}; done"
        ]
      }
      resources {
        network {
          port "db" {}
        }
      }
      service {
        name = "redis-cache"
        tags = ["global", "cache"]
        port = "db"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
          check_restart {
            limit = 2
            grace = "10s"
            ignore_warnings = false
          }
        }
      }
    }
  }
}
