#----------------------------------------------------------------------------
# This value can be supplied as a flag to nomad job run.
#   `nomad job run -var config_file=«path to config» job2.nomad`
# or as an environment variable
#   `export NOMAD_VAR_config_file=«path to config»`
#   `nomad job run job2.nomad`
#----------------------------------------------------------------------------
variable "config_file" {
  type = string
}

locals {
  config = jsondecode(file(var.config_file))
}

job "job2" {
  datacenters = local.config.datacenters

  group "job2" {
    task "job2" {
      driver = "docker"

      config {
        image = local.config.docker_image_job2
      }
    }
  }
}
