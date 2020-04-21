job "node" {
  datacenters = ["dc1"]
  type = "system"

  group "node" {
    task "plugin" {
      driver = "docker"

      config {
        image = "hetznercloud/hcloud-csi-driver:1.2.3"
        privileged = true
      }

      env {
        CSI_ENDPOINT="unix:///csi/csi.sock"    
        HCLOUD_TOKEN="«your token»"
      }

      csi_plugin {
        id        = "csi.hetzner.cloud"
        type      = "monolith"
        mount_dir = "/csi"
      }
    }
  }
}