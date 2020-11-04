job "example" {
  datacenters = ["dc1"]

  group "cache" {
    volume "test" {
      type      = "host"
      source    = "container-test"
      read_only = false
    }
    task "redis" {
      driver = "docker"
      volume_mount {
        volume      = "test"
        destination = "/host_vol"
      }
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
        volumes = [
          "/opt/nomad/volumes/container-test/folder1:/folder1",
          "/opt/nomad/volumes/container-test/folder2:/folder2"
        ]
     }

      resources { network { port "db" {} } }

      service {
        port = "db"
        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }
    }
  }
}
