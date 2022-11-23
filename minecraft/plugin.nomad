job "csi-plugin" {
  datacenters = ["dc1"]

  group "csi" {
    task "plugin" {
      driver = "docker"

      config {
        image      = "quay.io/k8scsi/hostpathplugin:v1.2.0"
        privileged = true
        args       = [
          "--drivername=csi-hostpath",
          "--v=5",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=foo",
        ]
      }

      csi_plugin {
        id        = "hostpath-plugin0"
        type      = "monolith"
        mount_dir = "/csi"
      }
    }
  }
}
