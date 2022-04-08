job "example" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group1" {
    network {
      port "dynamic_port1" {}

      port "static_port1" {
        static = 9999
      }

      port "static_port2" {
        static = 9998
      }
    }

    task "task1" {
      driver = "exec"

      config {
        command = "env"
      }
    }

    task "task2" {
      driver = "exec"

      config {
        command = "env"
      }
    }

  }
  group "group2" {

    task "task1" {
      driver = "exec"

      config {
        command = "env"
      }
    }

    task "task2" {
      driver = "exec"

      config {
        command = "env"
      }
    }
  }
}
