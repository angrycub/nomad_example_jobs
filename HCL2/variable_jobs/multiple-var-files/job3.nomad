variable "datacenters" {
  type        = list(string)
  description = "List of Nomad datacenters to run the job in. Defaults to `[\"dc1\"]`"
  default     = ["dc1"]
}

variable "docker_image" {
  type        = string
  description = "Shared docker image"
  default     = "redis"
}

variable "image_version_job3" {
  type        = string
  description = "Docker image version to run for job3"
  default     = "3"
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
