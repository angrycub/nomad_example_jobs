job "repro" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1

#    constraint {
#      attribute = "${attr.kernel.name}"
#      value = "darwin"
#    }

    task "echo-task" {
      driver = "exec"

      config {
        command = "local/bin/SleepyEcho.sh"
        args = ["2"]
      }

      artifact {
	      source = "https://angrycub-hc.s3.amazonaws.com/public/SleepyEcho.sh"
        destination = "local/bin"
      }
    }
  }
}
