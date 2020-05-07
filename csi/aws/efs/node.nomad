job "plugin-aws-efs-nodes" {
  datacenters = ["dc1"]
  type = "system"

  group "nodes" {
    task "plugin" {
      driver = "docker"

      config {
        image = "amazon/aws-efs-csi-driver:latest"

        args = [
          "--endpoint=unix:///csi/csi.sock",
          "--logtostderr",
          "--v=5",
        ]

        # node plugins must run as privileged jobs because they
        # mount disks to the host
        privileged = true
      }

      csi_plugin {
        id        = "aws-efs"
        type      = "monolith"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 200
        memory = 128 
      }
    }
  }
}

