variable "site_name" {
  type = string
  description = "The site_name is used to set the consul tag for the website. This makes them available at \"site_name.wordpress-sites.service.consul\""
}

job "my-website" {
  name = "wp-site-${var.site_name}"
  id = "wp-site-${var.site_name}"
  datacenters = ["dc1"]

  group "wordpress" {
    count = 2

    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "wordpress-sites"
      tags = ["${var.site_name}"]
      port = "http"

      check {
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "await-wordpress-db" {
      driver = "docker"

      template {
        destination = "local/await-db.sh"
        perms = 700
        data =<<EOT
#!/bin/sh
echo -n 'Waiting for wordpress-db service...'
until nslookup -port=8600 wordpress-db.service.consul ${NOMAD_IP_http} 2>&1 >/dev/null
do
  echo -n '.'
  sleep 2
  # There is a good opportunity to add a loop counter and a bail-out too, but
  # this script waits forever.
done
echo " Done."
EOT
      }

      config {
        image        = "alpine:latest"
        command      = "local/await-db.sh"
        network_mode = "host"
      }

      resources {
        cpu    = 200
        memory = 128
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "wordpress" {
      driver = "docker"

      template {
        data = <<EOH
{{- if service "wordpress-db" -}}
{{- with index (service "wordpress-db") 0 -}}
WORDPRESS_DB_HOST={{ .Address }}:{{ .Port }}
{{- end -}}
{{- end }}
WORDPRESS_DB_USER=wordpress
WORDPRESS_DB_PASSWORD=wordpress
WORDPRESS_DB_NAME=wordpress-${var.site_name}
  EOH

        destination = "local/envvars.txt"
        env = true
      }

      config {
        image = "wordpress:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}