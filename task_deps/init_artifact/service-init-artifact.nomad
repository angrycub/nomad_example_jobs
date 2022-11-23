job "init-artifacts" {
  datacenters = ["dc1"]

  group "test" {
    task "init" {
      driver = "exec"

      config {
        command = "${NOMAD_ALLOC_DIR}/linux-amd64-levant"
        args = ["-version"]
      }

     lifecycle {
        hook = "prestart"
      }

      template {
        destination = "alloc/hello.levant"
        data = <<EOH
NOMAD_ALLOC_ID:  [[ env "NOMAD_ALLOC_ID" ]]
EOH
      }

      artifact {
      	source = "https://github.com/hashicorp/levant/releases/download/0.2.9/linux-amd64-levant"
	      destination = "alloc"
      }

      resources {
        cpu    = 20
        memory = 10
      }
    }

    task "template" {
      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/renderTemplate.sh"
      }

      template {
        destination = "local/renderTemplate.sh"
        data = <<EOH
#!/bin/bash

SLEEP_SECS=$${SLEEP_SECS:-300} # provide default of 300 seconds
sleepLoop() { while true; do sleep $${SLEEP_SECS}; done }

echo "$(date) - Starting."

$${NOMAD_ALLOC_DIR}/linux-amd64-levant render $${NOMAD_ALLOC_DIR}/hello.levant;

# sleepLoop ensures that the task remains running to meet Nomad's
# requirement that services never stop. If this is a batch task,
# you can comment it out.
sleepLoop

EOH
      }

      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
