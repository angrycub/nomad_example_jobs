variable "datacenters" {
  type        = list(string)
  description = "Datacenters in which to run job."
  default     = ["dc1"]
}

variable "docker_image_job1" {
  type        = string
  description = "Image for job1 to run"
  default     = "redis:3"
}

job "job1" {
  datacenters = var.datacenters

  group "job1" {
    task "job1" {
      driver = "docker"

      config {
        image = var.docker_image_job1
      }
    }
  }
}
