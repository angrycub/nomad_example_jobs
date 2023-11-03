job "loki-monolith" {
  datacenters = ["dc1"]

  group "loki" {
    count = 1

    network {
      port "loki" {}
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki:2.6.1"
        ports = ["loki"]

        args = [
          "--config.file=/etc/loki/config/loki.yml",
        ]

        volumes = [
          "local/config:/etc/loki/config",
        ]
      }

      template {
        data = <<EOH
---
auth_enabled: false
server:
  http_listen_port: {{ env "NOMAD_PORT_loki" }}
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s
  wal:
    dir: /loki/wal
schema_config:
  configs:
  - from: 2020-05-15
    store: boltdb
    object_store: filesystem
    schema: v11
    index:
      prefix: index_
      period: 168h
storage_config:
  boltdb:
    directory: /loki/index
  filesystem:
    directory: /loki/chunks
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOH

        change_mode   = "signal"
        change_signal = "SIGHUP"
        destination   = "local/config/loki.yml"
      }

      resources {
        cpu    = 100
        memory = 256
      }

      service {
        name     = "loki"
        provider = "nomad"
        port     = "loki"

        check {
          type     = "http"
          path     = "/ready"
          interval = "10s"
          timeout  = "2s"
        }
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