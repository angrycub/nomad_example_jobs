variable "count"{
  type = number
  default = 11
}

locals {
  year = [{year="2023", count=0.7},{year="2017",count=0.3}]
}

job "sleeper" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    operator  = "set_contains_any"
    value     = "darwin,linux"
  }

  dynamic "group" {
    for_each = local.year
    labels = ["group-${group.value.year}"]

    content {
      count = ceil(var.count * group.value.count)

      constraint {
        attribute = "${meta.year}"
        value     = group.value.year
      }

      # need to prevent the task from being restarted on reconnect, if
      # we're stopped long enough for the node to be marked down

      reschedule {
        attempts  = 0
        unlimited = false
      }

      max_client_disconnect = "1h"

      task "task" {
        driver = "docker"

        config {
          image   = "busybox:1.29.2"
          command = "/bin/sleep"
          args    = ["1000"]
        }

        resources {
          cpu    = 50
          memory = 64
        }
      }
    }
  }
}