variable "datacenters" {
  type = list(string)
  description = "Path to JSON formatted shared job configuration."
}

variable "docker_image" {
  type = string
  description = "Shared docker image"
}

variable "image_version_job3" {
  type = string
  description = "Docker image version to run for job3"
}

job "job3" {
  datacenters = var.datacenters

  group "job3" {
    task "job3" {
      driver = "docker"

      config {
        image = "${var.docker_image}:${var.image_version_job3}"
      }
    }
  }
}
