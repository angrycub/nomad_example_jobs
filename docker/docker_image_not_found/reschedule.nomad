job "example" {
  datacenters = ["dc1"]
  group "group" {
    task "broken" {
      driver = "docker"
      config {
        image = "this_is_not_an_image:latest"
      }
    }
  }
}
