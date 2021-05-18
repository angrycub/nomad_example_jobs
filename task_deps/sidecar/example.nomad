job "example" {
  datacenters = ["dc1"]

  group "cache" {
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
        image = "redis:3.2"

        port_map {
          db = 6379
        }
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          mbits = 10
          port  "db"  {}
        }
      }
    }
  }
}
