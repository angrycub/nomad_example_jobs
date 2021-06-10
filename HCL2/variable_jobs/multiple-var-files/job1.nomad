variable "datacenters" {
  type = list(string)
  description = "Path to JSON formatted shared job configuration."
}

variable "docker_image" {
  type = string
  description = "Shared docker image"
}

variable "image_version_job1" {
  type = string
  description = "Docker image version to run for job1"
}

job "job1" {
  datacenters = var.datacenters

  group "job1" {
    task "job1" {
      driver = "docker"

      config {
        image = "${var.docker_image}:${var.image_version_job1}"
      }
    }
  }
}
