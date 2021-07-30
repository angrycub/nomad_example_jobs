job "scratch" {
  datacenters = ["dc1"]
  type        = "service"

  group "group" {
    volume "scratch" {
      type      = "host"
      source    = "scratch"
      read_only = false
    }

    count = 1

    task "2001" {
      driver = "docker"
      user = "2001:12001"

      config {
        image   = "alpine:latest"
        command = "/bin/sh"
        args    = ["-c", "while true; do sleep 500; done"]
      }

      volume_mount {
        volume      = "scratch"
        destination = "/scratch"
      }
    }

    task "2002" {
      driver = "docker"
      user = "2002:12001"

      config {
        image   = "alpine:latest"
        command = "/bin/sh"
        args    = ["-c", "while true; do sleep 500; done"]
      }

      volume_mount {
        volume      = "scratch"
        destination = "/scratch"
      }
    }
  }
}
