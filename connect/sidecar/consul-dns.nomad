job "testdns" {
  datacenters = ["dc1"]

  group "ubuntu" {
    network {
      mode = "bridge"
      # dns {
      #   servers = ["127.0.0.1"]
      # }
    }

    service {
      name = "ubuntu"
      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "consul-dns"
              local_bind_port  = 8600
            }
          }
        }
      }
    }

    task "ubuntu" {
      driver = "docker"
      config {
        image = "ubuntu"
        args = ["bash", "-c","while true; do sleep 300; done"]
      }
    }
  }
}

