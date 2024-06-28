job "airflow-db" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = false
    canary            = 0
  }

  affinity {
    attribute  = "${node.unique.name}"
    value = "client-0"
    weight    = 100
  }

  group "postgres" {
    count = 1

    restart {
      attempts = 2
      interval = "10m"
      delay    = "15s"
      mode     = "fail"
    }

    network{
      port "postgres"{
        static = 5432
        to = 5432
      }
    }
    service {
      name = "postgres"
      port = "postgres"
      # provider="nomad"
      # tags = [
      #   "traefik.enable=true",
      #   "traefik.tcp.routers.postgres.rule=HostSNI(`*`)",
      #   "traefik.tcp.routers.postgres.entryPoints=postgres",
      #   "traefik.tcp.routers.postgres.service=postgres",
      #   # services (needed for TCP)
      #   "traefik.tcp.services.postgres.loadbalancer.server.port=5432"
      # ]
      check {
        type     = "tcp"
        port     = "postgres"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "postgres" {
      driver = "docker"
      env {
        POSTGRES_USER= "airflow"
        POSTGRES_PASSWORD= "airflow"
        POSTGRES_DB= "airflow"
      }

      config {
        ports=["postgres"]
        image = "postgres:13"
        network_mode="host"
        volumes=[
          "local/postgres-db-volume:/var/lib/postgresql/data"
        ]

      }

      # resources {
      #   cpu    = 100
      #   memory = 1024
      # }
    }
  }

  group "redis" {
    count = 1

    network{
      port "redis"{
        static = 6379
        to = 6379
      }
    }
    restart {
      attempts = 2
      interval = "10m"
      delay    = "15s"
      mode     = "fail"
    }
    service {
      name = "redis"
      port = "redis"
      # provider="nomad"

      # tags = [
      #   # routers
      #   "traefik.tcp.routers.redis.rule=HostSNI(`*`)",
      #   "traefik.tcp.routers.redis.entryPoints=redis",
      #   "traefik.tcp.routers.redis.service=redis",
      #   # services (needed for TCP)
      #   "traefik.tcp.services.redis.loadbalancer.server.port=6379"
      # ]
      check {
        type     = "tcp"
        port     = "redis"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "redis" {
      driver = "docker"
      config {
        image = "redis:6"
        network_mode="host"
        ports=["redis"]
      }
      # resources {
      #   cpu    = 100
      #   memory = 1024
      # }
    }
  }
}
