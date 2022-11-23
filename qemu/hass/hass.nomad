job "home-assistant" {
  datacenters = ["dc1"]
  type        = "service"

  group "hass-vm" {
    network {
      mode = "host"
      port "hasswebui" {
        static = 8223
      }
    }

    task "home-assistant" {
      driver = "qemu"

      config {
        image_path        = "hassos_ova-4.16.qcow2"
        accelerator       = "kvm"
        graceful_shutdown = true
        args = [
          "nodefaults",
          "nodefconfig",
          "net nic,model=e1000",
          "smbios type=0,uefi=on",
        ]
      }

      artifact {
        source      = "https://github.com/home-assistant/operating-system/releases/download/4.16/hassos_ova-4.16.qcow2.gz"
        destination = "hassos_ova-4.16.qcow2"
        mode        = "file"
      }

      resources {
        cpu    = 100
        memory = 800
      }
    }
  }
}
