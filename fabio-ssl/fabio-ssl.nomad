job "fabio-stg" {
  datacenters = ["dc1"]
  type        = "system"

  group "fabio" {
    network {
      port "http" {
        static = 80
      }
      port "https" {
        static = 443
      }
      port "ui" {
        static = 9998
      }
      port "lb" {
        static = 9999
      }
    }

    service {
      name = "fabio-lb"
      tags = ["fabio"]
      port = "http"

      check {
        type     = "tcp"
        port     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    service {
      name = "fabio-lb-tls"
      tags = ["fabio"]
      port = "https"

      check {
        type     = "tcp"
        port     = "https"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    service {
      name = "fabio-ui"
      tags = ["fabio"]
      port = "ui"

      check {
        type     = "tcp"
        port     = "ui"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "fabio" {
      driver = "docker"

      config {
        image   = "fabiolb/fabio"
        volumes = ["/etc/fabio:/etc/fabio"]
        ports   = ["http", "https", "ui", "lb"]
      }

      resources {
        cpu    = 1000
        memory = 70
      }
    }
  }
}
