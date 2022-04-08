job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "http" {
        to = 80
      }
    }
    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:alpine"
        ports = ["http"]
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
      }

      template {
        destination = "conf.js"
        data        = <<EOH
window.env = {
  apiUrl: "http://example.com/api
}
EOH
      }
    }
  }
}
