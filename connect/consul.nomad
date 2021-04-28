job "connect-consul" {

  datacenters = ["dc1"]
  type = "batch"

  group "connect-consul" {
    network {
      mode = "bridge"
    }

    service {
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "consul"
              local_bind_port  = 8500
            }
          }
        }
      }
    }

    task "env" {
      driver = "exec"

      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      config {
        image = "env"
      }
    }
  }
}

