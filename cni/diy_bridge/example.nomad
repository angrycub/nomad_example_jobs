variable "dcs" {
  description = "Datacenters to run job in."
  type = list(string)
  default = ["dc1"]
}

job "example" {
  datacenters = ["dc1"]

  group "test" {
    network {
      mode = "cni/diybridge"
    }

    task "alpine" {
      driver = "docker"

      config {
        image = "busybox:latest"
        command = "sleep"
        args = ["infinity"]
      }
    }
  }
}
