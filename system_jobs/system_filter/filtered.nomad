job "filtered" {
  datacenters = ["dc1"]
  type = "system"
  group "cache" {
    constraint {
      attribute = "${attr.kernel.name}"
      operator  = "="
      value     = "windows"
    }
    task "job" {
      driver = "raw_exec"

      config {
        command = "C:\\Windows\\System32\\notepad.exe"
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
