job "sleepy" {
  datacenters = ["dc1"]
  type        = "batch"

  group "group" {
    count = 6

    network {
      port "http" {}
    }

    task "python" {
      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/files.py"
      }

      template {
        data        = <<EOH
#! /usr/bin/python

import datetime
import time
import sys
print(str(datetime.datetime.now())+" - Starting.")
sys.stdout.flush()
while True:
    print(str(datetime.datetime.now())+" - Sleeping for 5 seconds.")
    sys.stdout.flush()
    time.sleep(5)
print(str(datetime.datetime.now())+" - Ending.")
sys.stdout.flush()
EOH
        destination = "local/files.py"
      }

      resources {
        memory = 100
        cpu    = 100
      }
    }
  }
}
