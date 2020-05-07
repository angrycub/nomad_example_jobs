job "mysql-busybox" {
  datacenters = ["dc1"]
  type        = "service"

  group "mysql" {
    count = 1

    volume "mysql" {
      type      = "csi"
      read_only = false
      source    = "mysql"
    }

    task "busybox" {
      driver = "docker"

      volume_mount {
        volume      = "mysql"
        destination = "/srv"
        read_only   = false
      }

      config {
        image = "busybox:latest"
        command = "sh"
        args = ["-c","while true; do echo '.'; sleep 5; done"]
      }

      resources {
        cpu    = 100
        memory = 128 
      }
    }
  }
}

