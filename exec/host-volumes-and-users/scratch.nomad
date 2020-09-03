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

    task "nobody" {
      volume_mount {
        volume      = "scratch"
        destination = "/scratch"
      }

      driver = "exec"

      config {
        command = "bash"
        args    = ["-c", "while true; do sleep 500; done"]
      }
    }

    task "user1" {
      volume_mount {
        volume      = "scratch"
        destination = "/scratch"
      }

      driver = "exec"

      config {
        command = "bash"
        args    = ["-c", "while true; do sleep 500; done"]
      }

      user = "user1"
    }
  }
}
