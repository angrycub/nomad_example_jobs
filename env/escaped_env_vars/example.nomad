variable "dcs" {
  type        = list(string)
  description = "Datecenters to run job in."
  default     = ["dc1"]
}

job "example" {
  datacenters = var.dcs
  type        = "batch"

  group "group" {
    task "escaped" {
      driver = "exec"

      config {
        command = "run.sh"
        args = [
          "\\$$var1"
        ]
      }

      env = {
        var1 = "Some value"
      }

      template {
        destination = "run.sh"
        data      = <<EOT
#!/usr/bin/env bash
echo "$1 = (eval $1)"
EOT
      }
    }
  }
}