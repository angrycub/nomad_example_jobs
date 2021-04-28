job "alloc_folder" {
  datacenters = ["dc1"]

  group "group" {
    task "docker" {
      driver = "docker"

      config {
        image = "busybox:latest"
        command = "sh"
        args = ["-c", "while true; do echo $(date) | tee -a /my_data/output.txt; sleep 2; done"]
        volumes = ["alloc/data:/my_data"]

      }

      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
