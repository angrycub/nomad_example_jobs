job "cn-demo" {
  datacenters = ["dc1"]
  
  meta {
    version = "1"
  }

  group "generator" {
    network {
      port "api" {}
    }

    service {
      name = "uuid-api"
      port = "${NOMAD_PORT_api}"

      connect {
        native = true
      }
    }

    task "generate" {
      driver = "docker"

      config {
        image        = "hashicorpnomad/uuid-api:v3"
        network_mode = "host"
      }

      env {
        BIND = "0.0.0.0"
        PORT = "${NOMAD_PORT_api}"
      }
    }
  }

  group "frontend" {
    network {
      port "http" { 
        static = 25000
      }
    }

    service {
      name = "uuid-fe"
      port = "25000"

      connect {
        native = true
      }
    }

    task "frontend" {
      driver = "docker"

      config {
#        image        = "hashicorpnomad/uuid-fe:v3"
        image        = "registry.service.consul:5000/uuid-fe:latest"
        network_mode = "host"
      }

      env {
        UPSTREAM = "uuid-api"
        BIND     = "0.0.0.0"
        PORT     = "25000"
      }
    }
  }
}

