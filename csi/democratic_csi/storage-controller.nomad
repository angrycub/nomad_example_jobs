job "storage-controller" {
  datacenters = ["dc1"]
  type        = "service"

  group "controller" {
    network {
      mode = "bridge"

      port "grpc" {
        static = 9000
        to     = 9000
      }
    }

    task "controller" {
      driver = "docker"

      config {
        image = "democraticcsi/democratic-csi:latest"
        ports = ["grpc"]

        args = [
          "--csi-version=1.2.0",
          "--csi-name=org.democratic-csi.nfs",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config-file.yaml",
          "--log-level=debug",
          "--csi-mode=controller",
          "--server-socket=/csi-data/csi.sock",
          "--server-address=0.0.0.0",
          "--server-port=9000",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "truenas"
        type      = "controller"
        mount_dir = "/csi-data"
      }

      template {
        destination = "${NOMAD_TASK_DIR}/driver-config-file.yaml"

        data = <<EOH
config
EOH
      }

      resources {
        cpu    = 30
        memory = 50
      }
    }
  }
}

