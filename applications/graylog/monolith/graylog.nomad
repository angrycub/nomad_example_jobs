job "graylog" {
  datacenters = var.datacenters

  group "gl" {
    network {
      port "http" {
        to = 9000
      }

      port "mongo" {
        to = 27017
      }

      port "es_api" {
        to = 9200
      }

      port "es_cluster" {
        to = 9300
      }

      port "gelf_input" {
        static = 12201
      }
    }

    service {
      name     = "graylog"
      tags     = ["http"]
      provider = "nomad"
      port     = "http"
    }

    service {
      name     = "graylog"
      tags     = ["es-api"]
      provider = "nomad"
      port     = "es_api"
    }

    service {
      name     = "graylog"
      tags     = ["mongo"]
      provider = "nomad"
      port     = "mongo"
    }

    task "mongo" {
      driver = "docker"

      config {
        image = "mongo:5"
        ports = ["mongo"]

        mount {
          type   = "bind"
          source = "."
          target = "/data/db"
        }

      }

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }
    }

    task "elasticsearch" {
      driver = "docker"

      config {
        image = "docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.2"
        ports = ["es_api", "es_cluster"]

        mount {
          type   = "bind"
          source = "."
          target = "/usr/share/elasticsearch/data"
        }
      }

      env = {
        ES_JAVA_OPTS               = "-Xms512m -Xmx512m"
        "bootstrap.memory_lock"    = "true"
        "discovery.type"           = "single-node"
        "http.host"                = "0.0.0.0"
        "action.auto_create_index" = "false"
        "node.name" = "es01"
        "cluster.name" = "es-docker-cluster"
      }

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      resources {
        memory = 1024
      }
    }

    task "graylog" {
      driver = "docker"

      config {
        image = "graylog/graylog:${var.graylog_version}"
        ports = ["http", "gelf_input"]
      }

      env = {
        GRAYLOG_PASSWORD_SECRET     = var.password_secret
        GRAYLOG_ROOT_USERNAME       = var.root_username
        GRAYLOG_ROOT_PASSWORD_SHA2  = var.root_password_sha2
        GRAYLOG_HTTP_BIND_ADDRESS   = "0.0.0.0:9000"
        GRAYLOG_HTTP_EXTERNAL_URI   = "http://${NOMAD_ADDR_http}/"
        GRAYLOG_ELASTICSEARCH_HOSTS = "http://${NOMAD_ADDR_es_api}"
        GRAYLOG_MONGODB_URI         = "mongodb://${NOMAD_ADDR_mongo}/graylog"
      }

      resources {
        cpu    = 500
        memory = 640
      }
    }
  }
}

variable "datacenters" {
  type        = list(string)
  default     = ["dc1"]
  description = "Datacenters in which to run the job."
}

variable "graylog_version" {
  type        = string
  default     = "5.0"
  description = "Tag for graylog container to deploy"
}

variable "password_secret" {
  type        = string
  default     = "ABCDEFGHIJKLNMOPQRSTUVWXYZ"
  description = "The secret that is used for password encryption and salting"
}

variable "root_username" {
  type        = string
  default     = "admin"
  description = "Username of Graylog's root user"
}

variable "root_password_sha2" {
  type        = string
  default     = "8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918"
  description = "SHA2 hash of a password you will use for your initial login as Graylog's root user. Defaults to the SHA256 sum of \"admin\"."
}