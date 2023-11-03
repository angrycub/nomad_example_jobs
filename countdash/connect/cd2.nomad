job "countdash" {
  datacenters = ["dc1"]

  group "api" {
    network {
      mode = "bridge"
    }

    service {
      name = "count-api"
      port = "9001"
      // check {
      //   port = "9001"
      //   type = "http"
      //   path = "/"
      //   interval = "5s"
      //   timeout = "2s"
      // }
      connect {
        sidecar_service {}
      }
    }

    task "web" {
      driver = "docker"

      config {
//        image = "hashicorpdev/counter-api:v3"
        image = "hashicorpnomad/counter-api:v3"
      }
    }
  }

  group "dashboard" {
    network {
      mode = "bridge"

      port "http" {
        to = 9002
      }
    }

    service {
      name = "count-dashboard"
      port = "http"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port  = 8080
            }
          }
        }
      }
    }

    task "dashboard" {
      driver = "docker"

      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      config {
//        image = "hashicorpdev/counter-dashboard:v3"
        image = "hashicorpnomad/counter-dashboard:v3"
      }
    }
  }
}
