job "circuitpy_reader" {

  constraint {
    attribute = "${meta.devices.propmaker}"
    operator  = "is_set"
  }

  group "devices" {

    task "reader" {
      driver = "docker"
      config {
        image  = "alpine:3"
        tty    = true

        entrypoint = [
          "sh",
          "-c",
          <<EOS
          apk add screen
          screen /dev/propmaker 115200
          EOS
        ]
   
        devices = [
          {
            host_path      = "/dev/ttyACM0"
            container_path = "/dev/propmaker"            
          }
        ]
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
