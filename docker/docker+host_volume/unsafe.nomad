job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }
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
        image = "redis:7"
        ports = ["db"]
        volumes = [
          "/opt/nomad/volumes/container-test/folder1:/folder1",
          "/opt/nomad/volumes/container-test/folder2:/folder2"
        ]
     }

      resources {
        cpu    = 100
        memory = 128
      }

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
