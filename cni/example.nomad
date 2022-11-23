job "example" {
  datacenters = ["dc1"]

  group "test" {
    network {
      mode = "cni/mynet3"
    }

    task "alpine" {
      driver = "docker"

      config {
        image = "alpine:latest"
        config {
          command = "sh"
          args = ["-c", "while true; do sleep 300; done "]
        }
      }
    }
  }
}
