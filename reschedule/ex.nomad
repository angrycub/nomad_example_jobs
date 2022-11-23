job "example" {
  datacenters = ["dc1"]

  update {
    healthy_deadline  = "3m"
  }

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    reschedule {
      attempts  = 15
      interval  = "1h"
      max_delay = "120s"
      unlimited = false
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
          limit           = 2
          grace           = "10s"
          ignore_warnings = false
        }
      }
    }

    task "redis" {
      driver = "raw_exec"

      config {
        command = "bash"
        args    = [
          "-c", "SLEEP_SECS=2; while true; do echo $(date) -- Alive... going back to sleep for ${SLEEP_SECS}; sleep ${SLEEP_SECS}; done"
        ]
      }

      resources {
        memory = 10
      }
    }
  }
}
