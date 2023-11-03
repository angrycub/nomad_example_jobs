variable "datacenters" {
  type = list(string)
  default = ["dc1"]
}

variable "start_port" {
  type = number
  default = 19000
}

variable "count" {
  type = number
  default = 5
}

variable "container_image" {
  type = string
  default = "alpine"
}

variable "container_label" {
  type = string
  default = "latest"
}

variable "command" {
  type = string
  default = "sleep"
}

variable "args" {
  type = list(string)
  default = ["infinity"]
}

locals {
  container = "${var.container_image}:${var.container_label}"
  index = range(0,var.count)
  ports = [for i in local.index : var.start_port+i]
  idxPorts = zipmap(local.index, local.ports)
}

job "example" {
  datacenters = var.datacenters

  dynamic "group" {
    for_each = local.index
    labels = ["test_service_${group.value+1}"]
    content {
      network {
        port "foo" {
          static = local.idxPorts[group.value]
        }
      }
      service {
        provider = "nomad"
        port = "foo"
        name = "test-service"
        tags = ["test_service_${group.value+1}"]
      }
      task "sleep" {
        driver = "docker"
        config {
          image = local.container
          command = var.command
          args = var.args
        }
      }
    }
  }
}