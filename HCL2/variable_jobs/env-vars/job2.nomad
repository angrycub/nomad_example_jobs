variable "datacenters" {
  type        = list(string)
  description = "Datacenters in which to run job."
  default     = ["dc1"]
}

variable "docker_image_job2" {
  type        = string
  description = "Image for job2 to run"
  default     = "redis:3"
}

job "job2" {
  datacenters = var.datacenters

  group "job2" {
    task "job2" {
      driver = "docker"

      config {
        image = var.docker_image_job2
      }
    }
  }
}
