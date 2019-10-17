job "example" {
  datacenters = ["dc1"]
  type = "batch"
  group "nodes" {
    count = 1
    reschedule {
      attempts = 0
      unlimited = false
    }
    restart {
      attempts = 0
      mode = "fail"
    }
    task "payload" {
      driver = "exec"
      config {
        command = "/bin/bash"
        args    = ["-c", "echo \"Sleeping 5 seconds\"; sleep 5; echo \"Exiting with exit code 1\"; exit 1"]
      }
    }
  }
}
