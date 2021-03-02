job "postgres.nomad" {
  datacenters = ["dc1"]

  group "database" {
    network {
      port "db" {
        to = 5432
      }
    }

    service {
      name = "db"
      port = "db"

      check {
        type     = "tcp"
        port     = "db"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "pg-data" {
      type      = "host"
      source    = "pg-data"
      read_only = false
    }

    task "postgres" {
      driver = "docker"

      env {
        POSTGRES_PASSWORD="mysecretpassword"
#        POSTGRES_USER=""
#        POSTGRES_DB=""
        PGDATA="/var/lib/postgresql/data/pgdata"
      }

      volume_mount {
        volume      = "pg-data"
        destination = "/var/lib/postgresql/data"
      }

      config {
        image = "postgres"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}