variable "input_file" {
  type = string
  description = "local path to the redis configuration to inject into the job."
}

job "raw_file_delims.nomad" {
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
        left_delimiter = "🚫"
        right_delimiter = "🚫"
      }
    }
  }
}
