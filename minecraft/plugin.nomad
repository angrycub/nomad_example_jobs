job "csi-plugin" {
  datacenters = ["dc1"]

  group "csi" {
    task "plugin" {
      driver = "docker"

      config {
        image = "quay.io/k8scsi/hostpathplugin:v1.2.0"

        args = [
          "--drivername=csi-hostpath",
          "--v=5",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=foo",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "hostpath-plugin0"
        type      = "monolith"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 500
        memory = 256

        network {
          mbits = 10
          port  "plugin"{}
        }
      }
    }
  }
}

