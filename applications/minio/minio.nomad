job "minio" {
  datacenters = ["dc1"]
  priority    = 80

  group "storage" {
    network {
      port "api" {
        to = 9000
        static = 9000
      }
    }

    service {
      name = "minio"
      port = "api"

      check {
        type     = "tcp"
        port     = "api"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "minio-data" {
      type      = "host"
      source    = "minio-data"
      read_only = false
    }

    task "minio" {
      driver = "docker"

      env {
        MINIO_ROOT_USER = "AKIAIOSFODNN7EXAMPLE"
        MINIO_ROOT_PASSWORD = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
      }

      volume_mount {
        volume      = "minio-data"
        destination = "/data"
      }

      config {
        image = "minio/minio"
        args = ["server", "/data"]
        ports = ["api"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}

# docker run -p 9000:9000 \
#   --name minio1 \
#   -v /mnt/data:/data \
#   -e "MINIO_ROOT_USER=AKIAIOSFODNN7EXAMPLE" \
#   -e "MINIO_ROOT_PASSWORD=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
#   minio/minio server /data