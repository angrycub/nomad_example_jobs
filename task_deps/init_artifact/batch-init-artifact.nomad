job "init-artifacts" {
  datacenters = ["dc1"]
  type = "batch"

  group "test" {
    task "init" {
      template {
        data = <<EOH

NOMAD_ALLOC_ID:  [[ env "NOMAD_ALLOC_ID" ]]

EOH
        destination = "alloc/hello.levant"
      }
      artifact {
	source = "https://github.com/hashicorp/levant/releases/download/0.2.9/linux-amd64-levant"
	destination = "alloc"
      }
      driver = "exec"
      lifecycle {
        hook = "prestart"   
      } 
      config {
        command = "${NOMAD_ALLOC_DIR}/linux-amd64-levant"
        args = ["-version"]
      }
      resources {
        cpu    = 20
        memory = 10
      }
    }

    task "template" {
      template {
        data = <<EOH
#!/bin/bash

SLEEP_SECS=${SLEEP_SECS:-300} # provide default of 300 seconds
sleepLoop() { while true; do sleep ${SLEEP_SECS}; done }

echo "$(date) - Starting."

${NOMAD_ALLOC_DIR}/linux-amd64-levant render ${NOMAD_ALLOC_DIR}/hello.levant;

EOH
        destination = "local/renderTemplate.sh"
      }

      driver = "exec"
      config {
        command = "${NOMAD_TASK_DIR}/renderTemplate.sh"
      }
      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
