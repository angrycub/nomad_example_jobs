job "docker-iis" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "15m"
    auto_revert = false
    canary = 0
  }
  group "windows" {
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }
    constraint {
      attribute = "${attr.kernel.name}"
      operator  = "="
      value     = "windows"
    }
    task "iis-site" {
      driver = "docker"
      config {
        image = "voiselle/iis-dockerfile:v1"
        port_map {
          www = 80
        }
      }
      resources {
        cpu    = 500 
        memory = 256 
        network {
          mbits = 10
          port "www" { }
        }
      }
      service {
        name = "windows-docker-iis"
        tags = ["windows","iis"]
        port = "www"
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
