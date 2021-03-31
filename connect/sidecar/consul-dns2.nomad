job "testdns2" {
  datacenters = ["dc1"]

  group "ubuntu" {
    network {
      mode = "bridge"
      dns {
        servers = ["127.0.0.1"]
      }
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
      artifact {
        source = "http://10.0.0.236:8000/dnstest"
        destination = "local"
      }

      artifact {
        source = "https://github.com/coredns/coredns/releases/download/v1.8.3/coredns_1.8.3_linux_amd64.tgz"
        destination = "local"
      }

      template {
        destination = "local/Corefile"
        data =<<EOT
. {
  forward . dns://8.8.8.8
}

consul {
  log
  forward . dns://127.0.0.1:8600 {
    force_tcp
  }
}
EOT
      }

      config {
        image = "ubuntu"
        args = ["bash", "-c","/local/coredns -conf /local/Corefile & while true; do sleep 200; done"]
      }
    }
  }
}

