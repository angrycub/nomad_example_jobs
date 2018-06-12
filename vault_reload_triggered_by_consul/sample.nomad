job "sample" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1

    constraint {
      attribute = "${attr.kernel.name}"
      value = "linux"
    }

    task "task" {
      driver = "raw_exec"

      config {
        command = "local/bin/SleepyEcho.sh"
        args = ["3"]
      }

      artifact {
	      source = "https://angrycub-hc.s3.amazonaws.com/public/SleepyEcho.sh"
        destination = "local/bin"
      }

      template {
        data = <<EOH
CHANGE_SERIAL="{{key "service/sleepyecho/change_serial"}}"
EXTRAS="{{with secret "secret/sleepyecho/password"}}{{.Data.value}}{{end}}"
EOH
        destination = "secrets/file.env"
        env = true
}
    }
  }
}
