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

    task "sleepy-bash" {
      template {
        data = <<EOH
#!/bin/bash

echo "$(date) -- Starting sleepy."
echo "$(date) -- VAULT_TOKEN=${VAULT_TOKEN}"
echo "$(date) -- Going to sleep forever. Stop the job via Nomad when you would like."
while true
do 
  sleep 5
done
EOH
        destination = "local/sleepy.sh"
      }

      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/sleepy.sh"
      }
      
      vault {
        policies = ["nomad-client"]
        change_mode   = "signal"
        change_signal = "SIGUSR1"
      }

      resources {
        memory = 10
        cpu = 50
      }
    }
  }
}

