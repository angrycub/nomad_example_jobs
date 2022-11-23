variable "job_name" {
  type = string
  default = ""
}

locals {
  targets = {
    "1": "zpool"
    "2": "zmirror"
  }
  tasks = {
    "redis": {"name":"db","port":6379}
  }
  docker_versions = {
    "zpool": "redis:7"
    "zmirror": "redis:latest"
  }
  job_name = "%{ if var.job_name != "" }${var.job_name}%{ else }example%{ endif }"
}

job "example" {
  name = local.job_name
  datacenters = ["dc1"]

  dynamic "group" {
    for_each = local.targets
    labels = ["${local.job_name}-${group.value}"]
    content {
      network {
        dynamic "port" {
          labels = ["${local.job_name}-${group.value}-${port.key}-${port.value.name}-${port.value.port}"]
          for_each = local.tasks
          content {
            to = port.value.port
          }
        }
      }

      dynamic "task" {
        labels = ["${local.job_name}-${group.value}-${task.key}"]
        for_each = local.tasks

        content {
          driver = "docker"

          config {
            image = local.docker_versions[group.value]
            ports = ["${local.job_name}-${group.value}-${task.key}-${task.value.name}-${task.value.port}"]
          }
        }
      }
    }
  }
}
