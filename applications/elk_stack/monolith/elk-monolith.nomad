job "elk-docker" {
  datacenters = var.datacenters
  group "g1" {
    network {
      port "beats" {
        to = 5044
      }
      port "kibana" {
        to = 5601
      }
      port "es" {
        to = 9200
      }
      port "es-cluster" {
        to = 9300
      }
      port "ls-monitor" {
        to = 9600
      }
    }

    service {
      name     = "elk-docker"
      tags     = ["beats"]
      port     = "beats"
      provider = "nomad"
    }

    service {
      name     = "elk-docker"
      tags     = ["kibana"]
      port     = "kibana"
      provider = "nomad"
    }

    service {
      name     = "elk-docker"
      tags     = ["es"]
      port     = "es"
      provider = "nomad"
    }

    service {
      name     = "elk-docker"
      tags     = ["es-cluster"]
      port     = "es-cluster"
      provider = "nomad"
    }

    service {
      name     = "elk-docker"
      tags     = ["ls-monitor"]
      port     = "ls-monitor"
      provider = "nomad"
    }

    task "docker" {
      driver = "docker"

      config {
        image = "${var.container_image}:${var.container_tag}"
        ports = ["beats", "kibana", "es", "es-cluster", "ls-monitor"]

        mount {
          type   = "bind"
          source = "."
          target = "/var/lib/elasticsearch"
        }
      }

      env = {
        MAX_MAP_COUNT = 262144
      }

      resources {
        memory = 8192
        cpu    = 15000
      }
    }
  }
}

variable "datacenters" {
  type        = list(string)
  default     = ["dc1"]
  description = "Datacenters in which to run the job."
}

variable "container_image" {
  type        = string
  default     = "sebp/elk"
  description = "ELK Docker image name"
}

variable "container_tag" {
  type        = string
  default     = "oss-8.3.3"
  description = "Tag for ELK Docker image to deploy"
}

// variable "password_secret" {
//   type        = string
//   default     = "ABCDEFGHIJKLNMOPQRSTUVWXYZ"
//   description = "The secret that is used for password encryption and salting"
// }

// variable "root_username" {
//   type        = string
//   default     = "admin"
//   description = "Username of Graylog's root user"
// }

// variable "root_password_sha2" {
//   type        = string
//   default     = "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
//   description = "SHA2 hash of a password you will use for your initial login as Graylog's root user. Defaults to the SHA256 sum of \"admin\"."
// }
