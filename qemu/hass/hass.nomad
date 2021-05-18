job "home-assistant"{
    datacenters = ["dc1"]
    type = "service"
    priority = "100"
	group "hass-vm" {
        task "home-assistant" {
            driver = "qemu"
            artifact {
                source = "https://github.com/home-assistant/operating-system/releases/download/4.16/hassos_ova-4.16.qcow2.gz"
                destination ="hassos_ova-4.16.qcow2"
		mode = "file"
		}
            config {
                image_path        = "hassos_ova-4.16.qcow2"
                accelerator       = "kvm"
                graceful_shutdown = true
                args              = ["nodefaults",
                    "nodefconfig",
                    "net nic,model=e1000",
                    "smbios type=0,uefi=on",
                    ]
                }
            resources {
                cpu = 100,
                memory = 800
            }
        }
        network {
            mode = "host"
            port "hasswebui" {
                static = 8223
            }
        }
    }
}
