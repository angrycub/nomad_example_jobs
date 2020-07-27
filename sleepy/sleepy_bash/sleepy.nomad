job sleepy {
  datacenters = ["dc1"]
  group "group" {
    count = 1

## You might want to constrain this, so here's one to help
#    constraint {
#      attribute = "${attr.unique.hostname}"
#      operator  = "="
#      value     = "nomad-client-1.node.consul"
#    }

task "sleepy.sh" {
      template {
        data = <<EOH
#!/bin/bash

SLEEP_SECS=${SLEEP_SECS:-2} # provide default of 2 seconds
echo "$(date) - Starting. SLEEP_SECS=${SLEEP_SECS}"
while true; do echo "$(date) - Sleeping for ${SLEEP_SECS} seconds."; sleep ${SLEEP_SECS}; done

EOH
        destination = "local/sleepy.sh"
      }

      driver = "exec"
      config { command = "${NOMAD_TASK_DIR}/sleepy.sh" }
      resources { memory = 100 cpu = 100 }
    }
  }
}

