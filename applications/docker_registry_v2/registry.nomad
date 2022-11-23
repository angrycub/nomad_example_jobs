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

      template {
        destination = "secrets/htpasswd"
        data = <<EOH
user:$2y$05$kyEyguS/Sisz7SMjqKQZ1eQDCM7pSFiItkL9yiVIDOVyQfj8XTCAS
EOH
      }

      volume_mount {
        volume      = "docker-registry"
        destination = "/var/lib/registry"
      }

      env {
        REGISTRY_AUTH="htpasswd"
        REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm"
        REGISTRY_AUTH_HTPASSWD_PATH="/secrets/htpasswd"
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
