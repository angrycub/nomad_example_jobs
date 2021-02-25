job "args.nomad" {
  datacenters = ["dc1"]
  group "g1" {
    network { 
      port "http" {}
    }

    task "echo" {
      template {
        destination = "secrets/local.env"
        env = true
        data =<<EOT
MY_VAR={{ key "test/echo/content"|toJSON }}
EOT
      }
      driver = "docker"
      config {
        image = "hashicorp/http-echo:latest"
        ports = ["http"]
        args = [
          "-listen=:${NOMAD_PORT_http}",
          "-text=\"${MY_VAR}\"",
        ]
      }
    }
  }
}

