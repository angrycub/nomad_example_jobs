job "alpine" {
  datacenters = ["dc1"]

  group "alloc" {
    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    volume "jobVolume" {
      type      = "csi"
      read_only = false
      source    = "test-volume0"
    }

    task "docker" {
      driver = "docker"

      volume_mount {
        volume      = "jobVolume"
        destination = "/srv"
        read_only   = false
      }

      config {
        image = "alpine"
        command = "sleep"
        args = ["infinity"]
      }
    }
  }
}
