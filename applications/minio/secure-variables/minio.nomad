# minio is an AWS S3-compatible storage engine

job "minio" {
  datacenters = ["dc1"]
  priority    = 80

  group "storage" {
    network {
      port "api" {
        to     = 9000
        static = 9000
      }
    }

    service {
      name     = "minio"
      port     = "api"
      provider = "nomad"

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

      template {
        destination = "${NOMAD_SECRETS_DIR}/env.vars"
        env         = true
        change_mode = "restart"
        data =<<EOF
{{- with nomadVar "nomad/jobs/minio/storage/minio" -}}
MINIO_ROOT_USER = {{.root_user}}
MINIO_ROOT_PASSWORD = {{.root_password}}
{{- end -}}
EOF
      }
      volume_mount {
        volume      = "minio-data"
        destination = "/data"
      }

      config {
        image = "minio/minio"
        args  = ["server", "/data"]
        ports = ["api"]
      }
    }
  }
}
