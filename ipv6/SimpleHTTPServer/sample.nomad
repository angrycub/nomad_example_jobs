# This job will create a SimpleHTTPServer that is IPV6 enabled.  This will allow
# a user to browse around in an alloc dir.  Not spectacularly useful, but is a 
# reasonable facsimile of a real workload.
job http6 {
  datacenters = ["dc1"]
  group "group" {
    count = 1

    task "server" {
      template {
        data = <<EOH
#! /usr/bin/python

import BaseHTTPServer
import SimpleHTTPServer
import socket


class HTTPServer6(BaseHTTPServer.HTTPServer):
    address_family = socket.AF_INET6


if __name__ == '__main__':
    SimpleHTTPServer.test(ServerClass=HTTPServer6)
EOH
        destination = "local/files.py"
      }

      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/files.py"
        args = ["${NOMAD_PORT_http}"]
      }

      resources { memory = 10 cpu = 50 network { port "http" {} }
      }
    }
  }
}

