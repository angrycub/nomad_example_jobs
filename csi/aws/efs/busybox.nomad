job "efs-busybox" {
  datacenters = ["dc1"]
  type        = "service"

  group "group" {
    count = 1

    volume "jobVolume" {
      type      = "csi"
      read_only = false
      source    = "csiVolume"
    }

    task "busybox" {
      driver = "docker"

      volume_mount {
        volume      = "jobVolume"
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
