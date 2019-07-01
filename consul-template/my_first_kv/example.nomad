job "example" {
  datacenters = ["dc1"]
  group "cache" {
    task "redis" {
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
      }
      template {
        data = <<EOH
CONSUL_test="{{key "consul-server1/testData"}}"
EOH

        destination = "secrets/file.env"
        env         = true
      }
      driver = "docker"
      resources { network { port "db" {} } }
    }
  }
}
