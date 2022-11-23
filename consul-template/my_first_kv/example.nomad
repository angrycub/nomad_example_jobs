job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
      }

      template {
        destination = "secrets/file.env"
        env         = true
        data        = <<EOH
CONSUL_test="{{key "consul-server1/testData"}}"
EOH
      }
    }
  }
}
