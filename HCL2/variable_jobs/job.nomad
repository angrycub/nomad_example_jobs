variable "datacenters" {
  type = list(string)
  description = "List of Nomad datacenters to run the job in. Defaults to `[\"dc1\"]`"
  default = ["dc1"]
}

variable "docker_image" {
  type = string
  description = "Docker image for the job to run"
}

variable "image_version" {
  type = string
  description = "Version of the docker image to run"
}

job "job1" {
  datacenters = var.datacenters

  group "job1" {
    task "job1" {
      driver = "docker"

      config {
        image = "${var.docker_image}:${var.image_version}"
      }
    }
  }
}
