job "minecraft" {
  datacenters = ["dc1"]
  type        = "service"

  group "minecraft" {
    task "minecraft" {
      driver = "java"

      config {
        jar_path    = "/local/server.jar"
        args        = ["--nogui"]
        jvm_options = ["-Xms1024M", "-Xmx1024M"]
      }

      artifact {
        source = "https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"
      }

      template {
        # We have to render the eula.txt file in the allocation root directory
        # because the server.jar process is called with / as the current working
        # directory. We can traverse backward from the task directory to the
        # allocation's root directory with ../
        destination = "${NOMAD_TASK_DIR}/../eula.txt"
        data        = "eula=true"
      }

      resources {
        cpu    = 500
        memory = 1252
      }
    }
  }
}
