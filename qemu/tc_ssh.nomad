job "j1" {
  datacenters = ["dc1"]

  group "g1" {

    network {
      port "http" { 
        to = -1
      }
      port "ssh" {
        to = -1
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

    task "t1" {
      template {
        data = <<EOH
      Guest System
      EOH

        destination = "local/index.html"
      }

      artifact {
        source = "http://10.0.0.254:8000/tinycore.qcow2"
        destination = "tinycore.qcow2"
        mode = "file"
      }

      driver = "qemu"

      config {
        image_path = "tinycore.qcow2"

        ## Uncomment if KVM is available on your system
        accelerator = "kvm"

        args = [
          "-device",
          "e1000,netdev=user.0",
          "-netdev",
          "user,id=user.0,hostfwd=tcp::${NOMAD_PORT_http}-:80,hostfwd=tcp::${NOMAD_PORT_ssh}-:22",
#          "-drive", "file=fat:rw:/etc,format=raw,media=disk",
          "-drive", "file=fat:rw:./local,format=raw,media=disk"
        ]
      }
    }
  }
}

#-blockdev driver=qcow2,node-name=disk,file.driver=http,file.filename=http://example.com/image.qcow2
