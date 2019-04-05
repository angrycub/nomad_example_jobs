job "repro" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1

    task "echo-task" {
      driver = "exec"
      env {
          EXTRAS = "${VAULT_TOKEN}"
      }
      config {
        command = "local/bin/SleepyEcho.sh"
        args = ["2"]
      }
      vault {
        policies = ["nomad-client"]
        change_mode   = "signal"
        change_signal = "SIGUSR1"
      }
      artifact {
        source = "https://angrycub-hc.s3.amazonaws.com/public/SleepyEcho.sh"
        destination = "local/bin"
      }
    }
  }
}
