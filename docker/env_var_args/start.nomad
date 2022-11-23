job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  meta {
    run_uuid = "${uuidv4()}"
  }

  group "g1" {
    task "docker" {
      driver = "docker"

      config {
        image = "registry.service.consul:5000/envfun:latest"
      }
    }
  }
}
