job "wordpress-db" {
  datacenters = ["dc1"]

  group "database" {
    network {
      port "db" {
        to = 3306
      }
    }

    service {
      name = "wordpress-db"
      port = "db"

      check {
        type     = "tcp"
        port     = "db"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "wordpress-db" {
      type      = "host"
      source    = "wordpress-db"
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
        volume      = "wordpress-db"
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
}