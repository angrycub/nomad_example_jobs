variable "datacenters" {
  type = list(string)
  description = "Path to JSON formatted shared job configuration."
}

variable "docker_image_job1" {
  type = string
  description = "Image for job1 to run"
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
