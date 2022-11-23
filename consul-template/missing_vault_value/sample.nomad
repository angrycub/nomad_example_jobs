job sleepy {
  datacenters = ["dc1"]
  type        = "system"

  group "group" {
    task "sleepy.sh" {
      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/sleepy.sh"
      }

      restart {
        attempts = 3
        delay    = "30s"
        mode     = "delay"
      }

      template {
        destination = "local/sleepy.sh"
        data = <<EOH
#!/bin/bash
{{ $consulKey := printf "nomad/jobs/%s/%s/first_task.sh/running" (env "NOMAD_JOB_NAME") (env "NOMAD_ALLOC_ID") }}{{ $consulKey }}
#{{ secret $consulKey }}

while true; do echo "$(date) - Sleeping for ${SLEEP_SECS} seconds."; sleep ${SLEEP_SECS}; done

EOH
      }

      resources {
        memory = 10
        cpu    = 100
      }

      vault {
        policies = ["default"]
      }
    }
  }
}
