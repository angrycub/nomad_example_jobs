variable "input_file" {
  type = string
  description = "local path to the redis configuration to inject into the job."
}

job "raw_file_json.nomad" {
  datacenters = ["dc1"]

  group "services" {
    task "alpine" {
      driver = "docker"

      template {
        destination = "local/file.out"
      }

      config {
        image   = "alpine"
        command = "bash"
        args    = [
          "-c",
          "cat local/file.out; while true; do sleep 30; done",
        ]
      }
      
      template {
        destination = "local/file.out"
        data = "{{jsonDecode \"${jsonencode(file(var.input_file))}\"}}"
      }
    }
  }
}
