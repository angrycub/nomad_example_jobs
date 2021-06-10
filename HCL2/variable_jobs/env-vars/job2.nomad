variable "datacenters" {
  type = list(string)
  description = "Path to JSON formatted shared job configuration."
}

variable "docker_image_job2" {
  type = string
  description = "Image for job2 to run"
}

job "job2" {

  datacenters = var.datacenters
  type = "service"

  group "job2" {

    task "job2" {
      driver = "docker"

      config {
        image = var.docker_image_job2
      }
    }
  }
}
