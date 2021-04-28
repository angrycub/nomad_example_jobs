job sleepy {
  type = "system"
  datacenters = ["dc1"]
  group "group" {
    count = 1

    task "sleepy.sh" {
      restart {
        attempts = 3
        delay = "30s"
        mode = "delay"
      }
      template {
        data = <<EOH
#!/bin/bash
{{ $consulKey := printf "nomad/jobs/%s/%s/first_task.sh/running" (env "NOMAD_JOB_NAME") (env "NOMAD_ALLOC_ID") }}{{ $consulKey }} 
#{{ secret $consulKey }}

while true; do echo "$(date) - Sleeping for ${SLEEP_SECS} seconds."; sleep ${SLEEP_SECS}; done

EOH
        destination = "local/sleepy.sh"
      }

      driver = "exec"
      config { command = "${NOMAD_TASK_DIR}/sleepy.sh" }
      resources { memory = 10 cpu = 100
      }
    }
  vault { policies = ["default"] }
  }
}

