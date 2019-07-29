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
    task "python" {
      template {
        data = <<EOH
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

      driver = "exec"

      config {
        command = "python"
        args = ["${NOMAD_TASK_DIR}/files.py"]
        # command = "${NOMAD_TASK_DIR}/files.py"
      }

      resources {
        memory = 100
        cpu = 50
      }
    }
  }
}

