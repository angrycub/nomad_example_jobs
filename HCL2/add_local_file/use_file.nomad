variable "input_file" {
  type = string
  description = "local path to the redis configuration to inject into the job."
}

job "use_file.nomad" {
  datacenters = ["dc1"]

  group "services" {
    task "alpine" {
      driver = "docker"

      config {
        image   = "alpine"
        command = "sh"
        args    = [
          "-c",
          "cat local/file.out; while true; do sleep 30; done",
        ]
      }

      template {
        destination = "local/file.out"
        data = file(var.input_file)
      }
    }
  }
}
