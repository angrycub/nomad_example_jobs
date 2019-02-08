job "example" {
  datacenters = ["dc1"]

  group "cache" {
    task "redis" {
      driver = "docker"
      config {
        image = "redis:3.2"
        port_map { db = 6379 }
      }
      resources { network { port "db" {} } }
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
    }
  }
}
