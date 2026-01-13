job "mariadb" {
  datacenters = ["dc1"]

  group "database" {
    network {
      port "db" {}
    }
    volume "mysql" {
      type   = "host"
      source = "mysql"
    }
    task "maria" {
      driver = "docker"
      volume_mount {
        volume      = "mysql"
        destination = "/var/lib/mysql"
      }
      env {
        MYSQL_ROOT_PASSWORD ="mypass"
      }
      config {
        image = "mariadb/server:10.3"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }

      service {
        name = "mariadb"
        tags = ["persist"]
        port = "db"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
