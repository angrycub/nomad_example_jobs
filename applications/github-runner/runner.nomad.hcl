job "ghshr" {
  datacenters = ["*"] # default

  meta {
    info = "Runs a group of github self-hosted runners"
  }

  group "ghshr-group" {
    count = 1

    task "ghshr-task" {
      driver = "docker"

      config {
        image = "cvoiselle4hashi/testcontainer:latest"
        image_pull_timeout = "3m"
        auth_soft_fail = "true"
      }
    }
  }
}