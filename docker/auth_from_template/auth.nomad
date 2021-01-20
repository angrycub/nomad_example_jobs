job "auth" {

  type        = "service"
  datacenters = ["dc1"]

  group "docker" {

    task "redis" {

      template {
        destination = "local/secret.env"
        env         = true
        change_mode = "restart"
        data        = <<EOH
DOCKER_USER={{ key "kv/docker/config/user" }}
DOCKER_PASS={{ key "kv/docker/config/pass" }}
EOH
      }

      driver = "docker"

      config {
        image = "registry.service.consul:5000/redis:latest"
        auth {
          username = "${DOCKER_USER}"
          password = "${DOCKER_PASS}"
        }
      }

      resources {
        cpu    = 200
        memory = 100
      }
    }
  }
}
