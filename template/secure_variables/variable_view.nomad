job "variable" {
  datacenters = ["dc1"]

  group "www" {
    network {
      port "www" {
        to = 8080
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image          = "nginx:1.23.1-alpine"
        ports          = ["www"]
        auth_soft_fail = true
        volumes = [ 
          "local/nginx.conf:/etc/nginx/conf.d/default.conf",
          "local/www/index.html:/usr/share/nginx/html/index.html",
        ]
      }

      resources {
        cpu    = 500
        memory = 256
      }
      template {
        destination = "local/nginx.conf"
        data = <<EOF
error_log stderr info;
access_log stdout;
server {
  listen 8080;
  location / {
    root /usr/share/nginx/html/;
    index index.html;
  }
}
EOF
      }
      template {
        destination = "local/www/index.html"
        data = file("./template.tmpl")
      }
    }
  }
}
