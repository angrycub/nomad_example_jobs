job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  meta {
    version = "2"
  }

  group "nodes" {
    count = 6

    constraint {
      distinct_hosts = true
    }

    task "payload" {
      driver = "exec"

      config {
        command = "/bin/bash"
        args    = ["-c", "echo $VAULT_ADDR > test.txt"]
      }
    }
  }
}
