job "example" {
  datacenters = ["dc1"]

  group "test_service" {
    count = 5

    network {
      port "foo" {}
    }
    service {
      provider = "nomad"
      port = "foo"
      name = "test-service"
    }
    task "sleep" {
      driver = "docker"
      config {
        image = "alpine:latest"
        command = "sleep"
        args = ["infinity"]
      }
    }
  }
}
