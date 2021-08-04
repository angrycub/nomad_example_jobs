job "variable.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta {
    run_index = "${floor(var.run_index)}"
  }

  group "variable" {
    task "hello-world" {
      driver = "docker"

      config {
        image = "hello-world:latest"
      }
    }
  }
}

variable "run_index" {
  type = number
  description = "An integer that, when changed from the current value causes the job to restart."
  validation {
    condition = var.run_index == floor(var.run_index)
    error_message = "The run_index must be an integer."
  }
}