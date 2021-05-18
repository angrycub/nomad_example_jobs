job "exampleNUM" {
  datacenters = ["dc1"]

  group "cache" {
     ephemeral_disk {
        size = "11"
      }
    task "redis" {
      logs {
        max_files     = 1
        max_file_size = 10
      }
      driver = "docker"

      config {
        image = "busybox"
        command = "sh"
        args    = ["-c", "echo The service is running! && while true; do sleep 2; done"]
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}
