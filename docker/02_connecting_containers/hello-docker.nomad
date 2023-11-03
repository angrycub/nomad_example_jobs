job "hello-docker" {
  datacenters = ["dc1"]

  group "getting-started" {
    network {
      port "http" {
        to = 80
      }
    }

    task "website" {
      driver = "docker"

      config {
        image          = "docker/getting-started"
        ports          = ["http"]
        auth_soft_fail = true
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
