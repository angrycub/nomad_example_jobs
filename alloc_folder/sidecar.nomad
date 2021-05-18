job "alloc_folder" {
  datacenters = ["dc1"]

  group "group" {
    task "docker" {
      driver = "docker"

      config {
        image = "busybox:latest"
        command = "sh"
        args=["-c","while true; do echo $(date) | tee -a /alloc/output.txt; sleep 2; done"]
      }

      resources {
        cpu    = 100
        memory = 100
      }
    }

    task "exec" {
      driver = "exec"
      config {
        command = "tail"
        args = ["-f", "/alloc/output.txt"]
      }
      resources { cpu=100 memory=100 }

    }
  }
}
