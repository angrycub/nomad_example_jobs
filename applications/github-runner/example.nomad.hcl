job "job" {
  group "group" {
    task "task" {
      driver = "docker"

      config {
        image          = "index.docker.io/cvoiselle4hashi/testcontainer:latest"
        auth_soft_fail = true
      }
    }
  }
}
