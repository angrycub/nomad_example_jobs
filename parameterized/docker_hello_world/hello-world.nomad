job "hello-world.nomad" {
  datacenters = ["dc1"]
  type = "batch"
  
  parameterized { }

  group "containers" {
    task "hello" {
      driver = "docker"

      config {
        image = "hello-world:latest"
      }
    }
  }
}
