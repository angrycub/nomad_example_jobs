job "freedos" {
  datacenters = ["dc1"]

  group "g1" {
    network {
      mode = "bridge"
      port "webvnc" {}
    }

    service {
      name = "freedos"
      tags = ["sample"]
      port = "webvnc"

      check {
        type     = "tcp"
        port     = "webvnc"
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
        image = "registry.service.consul:5000/novnc"
        ports = ["webvnc"]
      }
    }

    task "freedos" {

      artifact {
        source      = "http://10.0.0.145:8000/freedos.img.tgz"
        destination = "local"
      }

      driver = "qemu"

      config {
        image_path  = "local/freedos.img"
        accelerator = "kvm"
        args = [
          "-vnc", "127.0.0.1:1"
        ]
      }
    }
  }
}
