job "uuid.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  meta {
    run_uuid = "${uuidv4()}"
  }

  group "uuid" {
    task "hello-world" {
      driver = "docker"

      config {
        image = "hello-world:latest"
      }
    }
  }
}
