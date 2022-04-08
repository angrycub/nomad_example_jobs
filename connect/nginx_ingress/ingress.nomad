job "ingress" {
  datacenters = ["dc1"]

  group "cache" {

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name = "ingress"
      tags = []
      port = "http"
      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:1.19.1-alpine"
        ports = ["http"]

        mounts = [
          {
            type = "bind"
            target = "/etc/nginx/nginx.conf"
            source = "local/nginx-proxy.conf"
            readonly = true
          }
        ]
      }

      template {
        destination = "local/nginx-proxy.conf"
        data = <<EOH
# daemon off;
master_process off;
pid nginx.pid;
error_log /dev/stdout;

events {}

http {
  access_log /dev/stdout;

  server {
    listen 8080 default_server;

    location / {
{{range connect "count-dashboard"}}
      proxy_pass https://{{.Address}}:{{.Port}};
{{end}}
      # these refer to files written by templates above
      proxy_ssl_certificate /secrets/cert.pem;
      proxy_ssl_certificate_key /secrets/cert.key;
      proxy_ssl_trusted_certificate /secrets/ca.crt;
    }
  }
}
EOH
      }

      template {
        destination = "secrets/ca.crt"
        data = <<EOH
{{ range caRoots}}{{.RootCertPEM}}{{end}}
EOH
      }

      template {
        destination = "secrets/cert.pem"
        data = <<EOH
{{ with caLeaf "ingress" }}{{ .CertPEM }}{{ end }}
EOH
      }

      template {
        destination = "secrets/cert.key"
        data = <<EOH
{{ with caLeaf "ingress" }}{{ .PrivateKeyPEM }}{{ end }}
EOH
      }
    }
  }
}
