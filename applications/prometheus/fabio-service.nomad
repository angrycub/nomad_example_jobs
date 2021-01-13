job "fabio" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "fabio-linux-amd64" {
    count = 3
#    constraint {
#      operator  = "distinct_hosts"
#      value     = "true"
#    }
    task "fabio-linux-amd64" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "amd64"
      }
      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "linux"
      }
      driver = "exec"
      config { command = "fabio-1.5.2-go1.8.3-linux_amd64" }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.2/fabio-1.5.2-go1.8.3-linux_amd64"
#        options {
#          checksum = "sha256:7dc786c3dfd8c770d20e524629d0d7cd2cf8bb84a1bf98605405800b28705198"
#        }
      }

      resources {
        cpu = 200
        memory = 32
        network {
          mbits = 1
          port "http" { static = "9999" }
          port "ui" { static = "9998" }
        }
      }
    }
  }
}

