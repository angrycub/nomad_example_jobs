job "example" {
  datacenters = ["dc1"]

  group "cache" {
    count = 3
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image          = "redis:7"
        ports          = ["db"]
        auth_soft_fail = true
        hostname       = "${attr.unique.hostname}"
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
