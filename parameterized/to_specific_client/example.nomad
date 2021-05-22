job "example.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  parameterized {
    meta_required = ["input_node_id"]
    meta_optional = []
    payload = "forbidden"
  }

  group "cache" {

    constraint {
      attribute = "${node.unique.id}"
      value = "${NOMAD_META_INPUT_NODE_ID}"
    }

    task "task" {
      driver = "docker"

      config {
        image = "alpine"
        command = "sh"
        args = [
          "-c",
          "env; while true; do sleep 300; done"
        ]
      }
    }
  }
}
