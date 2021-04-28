job "db" {
  datacenters = ["dc1"]
  group "db" {
    network {
      mode = "bridge"
    }
    service {
      name = "redis"
      port = "6379"
      connect {
        sidecar_service {}
      }
    }
    task "db" {           # The task stanza specifices a task (unit of work) within a group
      driver = "docker"      # This task uses Docker, other examples: exec, LXC, QEMU
      config {
        image = "redis:4-alpine" # Docker image to download (uses public hub by default)
        args = [
          "redis-server", "--requirepass", "turtle"
        ]  
      }
    } 
  }
}
