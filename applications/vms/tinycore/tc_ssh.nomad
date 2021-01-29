job "j1" {
  datacenters = ["dc1"]

  group "g1" {
    network {
      mode = "bridge"
      port "http" {
        to = 80
      }
      port "ssh" {
        to = 23
      }
      port "webvnc" {}
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

    task "novnc" {
      driver = "docker"

      env {
        NOVNC_PORT      = "${NOMAD_PORT_webvnc}"
        VNC_SERVER_IP   = "127.0.0.1"
        VNC_SERVER_PORT = "5901"
      }

      config {
        image = "voiselle/novnc"
        ports = ["webvnc"]
      }
    }

    task "t1" {
      template {
        data = <<EOH
      Guest System
      EOH

        destination = "local/index.html"
      }

      artifact {
        source = "http://10.0.0.188:8000/tinycore.qcow2.tgz"
      }

      driver = "qemu"

      config {
        image_path = "local/tinycore.qcow2"

        ## Uncomment if KVM is available on your system
        accelerator = "kvm"

        args = [
          "-drive", "file=fat:rw:/opt/nomad/data/alloc/${NOMAD_ALLOC_ID}/${NOMAD_TASK_NAME}/local,format=raw,media=disk",
        ]
        ports = ["ssh", "http"]
        vnc {
          enabled = true
          ip      = "127.0.0.1"
          display = 1
        }
      }
    }
  }
}
