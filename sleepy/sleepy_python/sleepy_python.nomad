job sleepy {
  datacenters = ["dc1"]

  group "group" {
    task "python" {
      driver = "exec"

      config {
        command = "python"
        args    = ["${NOMAD_TASK_DIR}/files.py"]
      }

      template {
        destination = "local/files.py"
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
      }

      resources {
        memory = 100
        cpu    = 50
      }
    }
  }
}
