job "my-website" {
  datacenters = ["dc1"]

  group "database" {
    network {
      port "db" {
        to = 3306
      }
    }

    service {
      name = "my-website-db"
      port = "db"

      check {
        type     = "tcp"
        port     = "db"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "my-website-db" {
      type      = "host"
      source    = "my-website-db"
      read_only = false
    }

    task "mysql" {
      driver = "docker"

      env {
        MYSQL_ROOT_PASSWORD="somewordpress"
        MYSQL_DATABASE="wordpress"
        MYSQL_USER="wordpress"
        MYSQL_PASSWORD="wordpress"
      }

      volume_mount {
        volume      = "my-website-db"
        destination = "/var/lib/mysql"
      }

      config {
        image = "mysql:5.7"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }

  group "wordpress" {
    network {
      port "http" {
        to = 80
      }
    }

    service {
      name = "my-website"
      tags = ["www"]
      port = "http"

      check {
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "await-my-website" {
      driver = "docker"

      config {
        image        = "alpine:latest"
        command      = "sh"
        args         = ["-c", "echo -n 'Waiting for service'; until nslookup -port=8600 my-website-db.service.consul ${NOMAD_IP_http} 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
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
{{- if service "my-website-db" -}}
{{- with index (service "my-website-db") 0 -}}
WORDPRESS_DB_HOST={{ .Address }}:{{ .Port }}
{{- end -}}
{{- end }}
WORDPRESS_DB_USER=wordpress
WORDPRESS_DB_PASSWORD=wordpress
WORDPRESS_DB_NAME=wordpress
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