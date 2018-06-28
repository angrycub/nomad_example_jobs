job "example" {
  datacenters = ["dc1"]
  type = "service"
  group "cache" {
    count = 1
    task "redis1" {
      constraint {
        attribute = "${attr.unique.hostname}"
        value     = "nomad-client-1.example.com"
      }
      driver = "docker"
      config {
        image = "redis:3.2"
      }
    }
    task "redis2" {
      constraint {
        attribute = "${attr.unique.hostname}"
        value     = "nomad-client-2.example.com"
      }
      driver = "docker"
      config {
        image = "redis:3.2"
      }
    }
  }
}
