job "csi-hostpath-driver" {
  datacenters = ["dc1"]

  group "csi" {
    task "driver" {
      driver = "docker"

      config {
        image = "quay.io/k8scsi/hostpathplugin:v1.2.0"

        args = [
          "--drivername=csi-hostpath",
          "--v=5",
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=foo",
        ]

        // all known CSI plugins will require privileged=true
        // because they need add mountpoints. in the ACLs
        // design we may make csi_plugin implicitly add the
        // appropriate privileges.
        privileged = true
      }

      csi_plugin {
        id        = "csi-hostpath"
        type      = "monolith"
        mount_dir = "/csi"
      }
    }
  }
}

