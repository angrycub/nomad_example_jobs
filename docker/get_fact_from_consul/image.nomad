job "image.nomad" {
  datacenters = ["dc1"]
  group "g1" {
    network { 
      port "db" {}
    }

    task "redis" {
      template {
        destination = "secrets/local.env"
        env = true
        data =<<EOT
VERSION_TAG={{ key "test/redis/docker-tag"|toJSON }}
EOT
      }
      driver = "docker"
      config {
        image = "redis:${VERSION_TAG}"
        ports = ["db"]
      }
    }
  }
}
