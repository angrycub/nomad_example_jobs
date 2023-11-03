job "nomad-vault-demo" {
  datacenters = ["dc1"]

  group "demo" {

    network {
      port "http" {
        to = 8080
      }
      ## You might need to point the container's DNS to a
      ## resolver that cananswer Consul queries at port 53.
      # dns {
      #   servers = ["x.x.x.x"]
      # }
    }

    task "server" {

      vault {
        policies = ["access-tables"]
      }

      driver = "docker"
      config {
        image = "hashicorp/nomad-vault-demo:latest"
        ports = ["http"]

        volumes = [
          "secrets/config.json:/etc/demo/config.json"
        ]
      }

      template {
        data = <<EOF
{{ with secret "database/creds/accessdb" }}
  {
    "host": "database.service.consul",
    "port": 5432,
    "username": "{{ .Data.username }}",
    "password": {{ .Data.password | toJSON }},
    "db": "postgres"
  }
{{ end }}
EOF
        destination = "secrets/config.json"
      }

      service {
        name = "nomad-vault-demo"
        port = "http"

        tags = [
          "urlprefix-/",
        ]

        check {
          type     = "tcp"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}

