job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }
    task "redis" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["db"]
      }
      resources {
        cpu    = 100
        memory = 128
      }
      service {
        name = "redis"
        tags = ["cache"]
        port = "db"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "faily-mcfailface" {
      driver = "exec"
      config {
        command = "/bin/bash"
        args = ["-c", "echo \"I don't feel so good....\"; sleep 5; echo \"see... I told you I was sick...\"; exit 1"]
      }
      resources {
        cpu    = 50
        memory = 32
      }
    }
  }
}
