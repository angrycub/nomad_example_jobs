job "countdash" {
  datacenters = ["dc1"]
  group "api" {
    task "web" {
      driver = "docker"
      config {
        image = "hashicorpnomad/counter-api:v1"
      }
      resources {
        network {
          port "count_api" {
            static = 9001
          }
        }
      }
    }
    task "dashboard" {
      driver = "docker"
      env {
        COUNTING_SERVICE_URL = "http://127.0.0.1:9001"
      }
      config {
        image = "hashicorpnomad/counter-dashboard:v1"
      }
      resources {
        network {
          port "dashboard" {
            static = 9002
          }
        }
      }
    }
  }
}

