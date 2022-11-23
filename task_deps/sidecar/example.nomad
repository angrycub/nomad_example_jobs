job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port  "db"  {}
    }

    task "remote_syslog_stdout" {
      driver = "docker"

      config {
        image = "octohost/remote_syslog"
        args = [
         "-p", "29655", "-d", "logs5.papertrailapp.com", "/alloc/logs/redis.stdout.0"
        ]
     }

      lifecycle {
        sidecar = true
        hook = "prestart"
      }
    }

    task "remote_syslog_stderr" {
      driver = "docker"

      config {
        image = "octohost/remote_syslog"
        args = [
         "-p", "29655", "-d", "logs5.papertrailapp.com", "/alloc/logs/redis.stderr.0"
        ]
     }

      lifecycle {
        sidecar = true
        hook = "prestart"
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
        }
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
