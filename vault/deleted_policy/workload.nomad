job sleepy {
  datacenters = ["dc1"]

  group "group" {
    task "sleepy-bash" {
      driver = "raw_exec"

      config {
        command = "bash"
        args = ["${NOMAD_TASK_DIR}/sleepy.sh"]
      }

      template {
        destination = "local/sleepy.sh"
        data        = <<EOH
#!/bin/bash

echo "$(date) -- Starting sleepy."
echo "$(date) -- NOMAD_TASK_DIR=${NOMAD_TASK_DIR}"
echo "$(date) -- VAULT_TOKEN=${VAULT_TOKEN}"
echo "$(date) -- Going to sleep forever. Stop the job via Nomad when you would like."
while true
do
  sleep 5
done
EOH
      }

      resources {
        memory = 10
        cpu    = 50
      }

      vault {
        policies      = ["my-cool-policy"]
        change_mode   = "restart"
      }
    }
  }
}
