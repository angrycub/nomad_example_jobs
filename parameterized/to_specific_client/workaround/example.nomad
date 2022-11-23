variable "node_id" {
  type        = string
  description = "The destination's Nomad node ID. Must be the full ID from `nomad node status -verbose`"

  # This default is here to allow for testing purposes.
  default = "not_a_node"
}

job "example.nomad" {
  datacenters = ["dc1"]
  type        = "batch"

  group "cache" {
    constraint {
      attribute = "${node.unique.id}"
      value     = var.node_id
    }

    task "task" {
      driver = "docker"

      config {
        image   = "alpine"
        command = "sh"
        args = [
          "-c",
          "env; sleep 5;"
        ]
      }
    }
  }
}
