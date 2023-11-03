job "postgres-nomad-demo" {
  datacenters = ["dc1"]


  group "db" {
    network {
      port  "db"{
        static = 5432
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "hashicorp/postgres-nomad-demo:latest"
        ports = ["db"]
      }

      service {
        name = "database"
        port = "db"

        check {
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}

