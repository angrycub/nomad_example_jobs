job "example" {
  datacenters = ["dc1"]
  type = "batch"
  group "group1" {
    task "task1" {
      driver = "exec"
      config {
        command = "env"
      }
      resources {
        network {
          port "dynamic_port1" {}
          port "static_port1" { static = 9999 }
        }
      }
    }
    task "task2" {
      driver = "exec"
      config {
        command = "env"
      }
      resources {
        network {
          port "dynamic_port1" {}
          port "static_port2" { static = 9998 }
        }
      }
    }

  }
  group "group2" {
    task "task1" {
      driver = "exec"
      config {
        command = "env"
      }
      resources {
        network {
          port "dynamic_port1" {}
          port "static_port1" { static = 9999 }
        }
      }
    }
    task "task2" {
      driver = "exec"
      config {
        command = "env"
      }
      resources {
        network {
          port "dynamic_port1" {}
          port "static_port2" { static = 9998 }
        }
      }
    }
  }
}
