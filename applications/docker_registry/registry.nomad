job "registry" {
  datacenters = ["dc1"]
  priority    = 80

  group "docker" {
    network {
      port "registry" {
        to     = 5000
        static = 5000
      }
    }

    service {
      name = "registry"
      port = "registry"

      check {
        type     = "tcp"
        port     = "registry"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "docker-registry" {
      type      = "host"
      source    = "docker-registry"
      read_only = false
    }

    task "container" {
      driver = "docker"

      volume_mount {
        volume      = "docker-registry"
        destination = "/var/lib/registry"
      }

      config {
        image = "registry"
        ports = ["registry"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
