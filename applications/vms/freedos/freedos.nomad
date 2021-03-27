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
        image = "voiselle/novnc"
        ports = ["webvnc"]
      }
    }

    task "freedos" {

      artifact {
        source      = "https://github.com/angrycub/nomad_example_jobs/raw/main/applications/vms/freedos/freedos.img.tgz"
        destination = "local"
        options {
          checksum  = "sha256:8d2817126bf46ba2b4fca0b0c49eed2cc208c6f6448651e82c6d973fcba36569"
        }
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
