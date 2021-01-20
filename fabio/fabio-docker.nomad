job "fabio" {
  datacenters = ["dc1"]
  type        = "system"

  update {
    stagger      = "5s"
    max_parallel = 1
  }

  group "linux-amd64" {
    network {
      port "http" {
        static = 9999
      }

      port "ui" {
        static = 9998
      }
    }

    service {
      tags = ["fabio", "lb"]
      port = "ui"

      check {
        name     = "fabio ui port is alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }

      check {
        name     = "fabio health check"
        type     = "http"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "fabio" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "amd64"
      }

      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "linux"
      }

      env {
       ## Add if your consul agent is not listening on 127.0.0.1:8500 
       # registry_consul_addr = "${attr.unique.network.ip-address}:8500"

       ## Add if your Consul cluster is ACL-enabled.
       # registry_consul_token = "«add if you have a consul enabled cluster»"
      }

      driver = "docker"

      config { 
        image = "fabiolb/fabio:latest"
        network_mode = "host"
        ports = ["proxy","ui"]
      }

      resources {
        cpu    = 200
        memory = 150 
      }
    }
  }
}
