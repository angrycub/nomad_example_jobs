job "csi-hostpath" {
  datacenters = ["dc1"]
  type        = "system"

  group "nodes" {
    task "plugin" {
      driver = "docker"

      config {
        image        = "k8s.gcr.io/sig-storage/hostpathplugin:v1.9.0"

        args = [
          "--v=5",
          "--drivername=csi-hostpath",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${attr.unique.hostname}",
        ]
        privileged = true
      }

      csi_plugin {
        id                      = "csi_hostpath"
        type                    = "monolith"
        mount_dir               = "/csi"
        health_timeout          = "30s"
      }

      resources {
        cpu    = 250
        memory = 128
      }
    }
  }
}