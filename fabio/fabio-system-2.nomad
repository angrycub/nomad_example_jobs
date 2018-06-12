job "fabio" {
  datacenters = ["dc1"]

  type = "system"
  update {
    stagger = "5s"
    max_parallel = 1
  }
  group "fabio-win" {
    task "fabio-windows-amd64" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "amd64"
      }
      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "windows"
      }
      driver = "raw_exec"
      config { command = "fabio-1.5.2-go1.8.3-windows_amd64.exe" }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.2/fabio-1.5.2-go1.8.3-windows_amd64.exe"
#        options {
#          checksum = "sha256:7dc786c3dfd8c770d20e524629d0d7cd2cf8bb84a1bf98605405800b28705198"
#        }
      }

      resources {
        cpu = 200
        memory = 32
        network {
          mbits = 1
          port "http" { static = 9999 }
          port "ui" { static = 9998 }
        }
      }
    }
  }
  group "fabio-linux-arm" {
    task "fabio-linux-arm" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "arm"
      }
      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "linux"
      }
      driver = "exec"
      config { command = "fabio-1.5.2-go1.8.3-linux_arm" }
      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.2/fabio-1.5.2-go1.8.3-linux_arm"
       options {
      }

      resources {
        cpu = 200
        memory = 32
        network {
          mbits = 1
          port "http" {}
          port "ui" {}
        }
      }
    }
  }
  group "fabio-linux-amd64" {
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
          port "http" {}
          port "ui" {}
        }
      }
      service {
        tags = ["fabio", "lb"]
        port = "ui"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}

