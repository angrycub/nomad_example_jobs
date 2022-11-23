#----------------------------------------------------------------------------
# This value can be supplied as a flag to nomad job run.
#   `nomad job run -var config_file=«path to config» job1.nomad`
# or as an environment variable
#   `export NOMAD_VAR_config_file=«path to config»`
#   `nomad job run job1.nomad`
#----------------------------------------------------------------------------
variable "config_file" {
  type = string
  description = "Path to JSON formatted shared job configuration."
}

locals {
  config = jsondecode(file(var.config_file))
}

job "job1" {
  datacenters = local.config.datacenters

  group "job1" {
    task "job1" {
      driver = "docker"

      config {
        image = local.config.docker_image_job1
      }
    }
  }
}
