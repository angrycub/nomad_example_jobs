job "vm-dc1" {
  datacenters = ["dc1"]

  meta {
    datacenter = "dc1"
    team       = "myTeam"
  }

  update {
    max_parallel     = 1
    min_healthy_time = "10s"
    healthy_deadline = "2m"
    auto_revert      = false
    canary           = 0
  }

  group "vm-myTeam" {
    network {
      port "http" {
        static = "8428"
      }
    }

    service {
      name = "vm-myTeam-dc1"
      tags = ["vm-myTeam", "dc1"]
      port = "http"
      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "victoriametrics" {
      driver = "docker"

      config {
        #        image = "victoriametrics/victoria-metrics:v${version}"
        image = "victoriametrics/victoria-metrics:latest"
        args  = [
          "-maxConcurrentInserts=128",
          "-insert.maxQueueDuration=2m0s"
        ]
        ports = ["http"]
      }

      resources {
        cpu    = 2000
        memory = 512
      }
    }
  }
}