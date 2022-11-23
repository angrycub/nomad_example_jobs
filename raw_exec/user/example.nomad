job "raw_exec" {
  datacenters = ["dc1"]
  type = "batch"
  group "user" {
    task "test" {
      driver = "raw_exec"
      user = "nomad"

      config {
	command = "/usr/bin/whoami"
        args = []
      }

      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
