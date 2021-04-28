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
        args    = ["-c", "echo 'eula=true' > /var/volume/eula.txt; cp local/server.jar /var/volume"]
      }

      artifact {
        source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
        destination = "local"
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "minecraft" {
      driver = "java"

      config {
        jar_path = "/var/volume/server.jar"
        args    = ["--nogui"],
        jvm_options = ["-Xms1024M", "-Xmx2048M"]
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

