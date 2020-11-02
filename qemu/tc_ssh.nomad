job "j1" {
  datacenters = ["dc1"]

  group "g1" {
    task "t1" {
      template {
        data = <<EOH
      Guest System
      EOH

        destination = "local/index.html"
      }

      artifact {
        source = "«replace with path to tinycore.qcow2»"
      }

      resources {
        network {
          port "http"{}
          port "ssh"{}
        }
      }

      service {
        tags = ["tag1"]
        port = "http"

        check {
          type     = "http"
          port     = "http"
          path     = "/index.html"
          interval = "10s"
          timeout  = "2s"
        }
      }

      driver = "qemu"

      config {
        image_path = "local/tinycore.qcow2"

        ## Uncomment if KVM is available on your system
        #        accelerator = "kvm"

        args = [
          "-device",
          "e1000,netdev=user.0",
          "-netdev",
          "user,id=user.0,hostfwd=tcp::${NOMAD_PORT_http}-:80,hostfwd=tcp::${NOMAD_PORT_ssh}-:22",
        ]

        # , "-drive", "file=fat:rw:/opt/nomad/data/alloc/${NOMAD_ALLOC_ID}/${NOMAD_TASK_NAME}/local,format=raw,media=disk"
      }
    }
  }
}
