job "minecraft" {
  datacenters = ["dc1"]
  type        = "service"

  group "minecraft" {
    volume "minecraft" {
      type   = "host"
      source = "minecraft"
    }

    task "eula" {
      driver = "exec"

      volume_mount {
        volume      = "minecraft"
        destination = "/var/volume"
      }

      config {
        command = "/bin/sh"
        args    = ["-c", "echo 'eula=true' > /var/volume/eula.txt"]
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "minecraft" {
      driver = "exec"

      config {
        command = "/bin/sh"
        args    = ["-c", "cd /var/volume && exec java -Xms1024M -Xmx2048M -jar /local/server.jar --nogui; while true; do sleep 5; done"]
      }

      artifact {
        source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
        destination = "/var/volume"
      }

      resources {
        cpu    = 500 
        memory = 500
      }

      volume_mount {
        volume      = "minecraft"
        destination = "/var/volume"
      }
    }
  }
}

