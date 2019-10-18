job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "nginx" {
      template {
        destination = "conf.js"

        data = <<EOH
window.env = {
  apiUrl: "http://example.com/api
}
EOH
      }

      driver = "docker"

      config {
        image = "nginx:alpine"

        mounts = [
          {
            type     = "bind"
            target   = "/usr/share/nginx/html/admin/conf.js"
            source   = "conf.js"
            readonly = false

            bind_options {
              propagation = "rshared"
            }
          },
        ]

        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          mbits = 10
          port  "http"{}
        }
      }
    }
  }
}
