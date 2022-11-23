job "sample" {
  datacenters = ["dc1"]

  group "group" {
    constraint {
      attribute = "${attr.kernel.name}"
      value     = "linux"
    }

    task "task" {
      driver = "raw_exec"

      config {
        command = "local/bin/SleepyEcho.sh"
        args    = ["3"]
      }

      artifact {
        source      = "https://angrycub-hc.s3.amazonaws.com/public/SleepyEcho.sh"
        destination = "local/bin"
      }

      template {
        destination = "secrets/file.env"
        env         = true
        data        = <<EOH
CHANGE_SERIAL="{{key "service/sleepyecho/change_serial"}}"
EXTRAS="{{with secret "secret/sleepyecho/password"}}{{.Data.value}}{{end}}"
EOH
      }
    }
  }
}
