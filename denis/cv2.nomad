job "app1" {
  datacenters = ["dc1"]
  group "counter" {
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
    network {
      mode = "bridge"
      port "http" {
  
        to     = 5678
      }
    }
    service {
      name = "webapp-proxy"
      port = "http"
      connect {
        sidecar_service {
            proxy {
                upstreams {
                  destination_name = "redis"
                  local_bind_port = 6479
                }
            }
        }
      }
    }
    service {
      name = "webapp"
      port = "http"
      tags = ["urlprefix-/"]
      check {
        name     = "HTTP Health Check"
        type     = "http"
        port     = "http"
        path     = "/health"
        interval = "5s"
        timeout  = "2s"
      }
    }
    
    task "app" {
      driver = "docker"      
      config {
        image = "hashicorp/http-echo"
        args = ["-text", "ZOMG WOW~~~~hello world"] 
      }
      resources {
        memory = 50
      }
    }
  }
}
