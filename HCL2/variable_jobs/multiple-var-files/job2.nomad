variable "datacenters" {
  type = list(string)
  description = "Path to JSON formatted shared job configuration."
}

variable "docker_image" {
  type = string
  description = "Shared docker image"
}

variable "image_version_job2" {
  type = string
  description = "Docker image version to run for job2"
}

job "job2" {
  datacenters = var.datacenters

  group "job2" {
    task "job2" {
      driver = "docker"

      config {
        image = "${var.docker_image}:${var.image_version_job2}"
      }
    }
  }
}
