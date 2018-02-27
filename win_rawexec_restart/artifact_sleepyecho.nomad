job "repro" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1

    constraint {
      attribute = "${attr.kernel.name}"
      value = "windows"
    }

    task "artifact" {
      driver = "raw_exec"

      template {
        data = <<EOH
EXTRAS="{{ key "sleepyecho/extra" }}"
EOH
        destination = "secrets/file.env"
        env         = true
      }

      config {
        command = "powershell.exe"
        args = ["local/bin/SleepyEcho.ps1"]
      }

      artifact {
	source = "https://angrycub-hc.s3.amazonaws.com/public/SleepyEcho.ps1"
        destination = "local/bin"
      }
    }
  }
}
