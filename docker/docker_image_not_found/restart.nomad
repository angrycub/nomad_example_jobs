job "restart" {
  datacenters = ["dc1"]
  meta {
    "serial_num" = "2"
  }
  group "group" {
    restart {
      attempts = 2
      delay    = "30s"
      interval = "1m"
      mode     = "delay"
    }
    task "broken" {
      driver = "docker"
      config {
        image = "this_is_not_an_image:latest"
      }
    }
  }
}
