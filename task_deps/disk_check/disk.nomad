# this job will hopefully die if the node doesn't have
# enough disk space to service the job
job "lifecycle" {
  datacenters = ["dc1"]
  type = "service"

  group "cache" {
    # disable deployments
    update {
      max_parallel = 0
    }
    task "init" {
      template {
        data = <<EOH
#!/bin/bash

GBFREE=$(($(stat -f --format="%a*%S/1073741824" .)))
if [[ $GBFREE -lt $1 ]]
then
  echo "ERROR: Not enough disk free.  Wanted $1 gb, had $GBFREE available." 
  exit 1
fi

EOH
        destination = "local/diskfree.sh"
      }

      driver = "exec"
      lifecycle {
        hook = "prestart"
      } 
      config {
        command = "${NOMAD_TASK_DIR}/diskfree.sh"
        args = ["3"]
      }
      resources {
        cpu    = 20
        memory = 10
      }
    }

    task "zebra-main-app" {
      driver = "docker"
      config {
        image = "redis:3.2"
      }
      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
