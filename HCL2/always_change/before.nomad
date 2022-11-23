job "before.nomad" {
  datacenters = ["dc1"]
  type = "batch"

  group "before" {
    task "hello-world" {
      driver = "docker"

      config {
        image = "hello-world:latest"
      }
    }
  }
}
