job "example" {
  datacenters = ["dc1"]

  group "cache" {
    count = 3
    update {
      max_parallel     = 1
      canary           = 3
      min_healthy_time = "10s"
      healthy_deadline = "5m"
      progress_deadline = "10m"
      auto_revert      = true
      auto_promote     = false
    }

    task "echo" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"
        args = ["-text", "hello world"] 

        port_map {
          http = 5678
        }
      }

      resources {
        cpu    = 100
        memory = 50 

        network {
          port  "http"  {}
        }
      }
      service {
        port = "http"
        tags = ["urlprefix-/"]
        check {
          type     = "http"
          port     = "http"
          path     = "/"
          interval = "5s"
          timeout  = "2s"
        }
      }
    }
  }
}
