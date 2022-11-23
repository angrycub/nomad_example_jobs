job "myjobname" {
  type        = "service"
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "mygroup1" {
    count = 1

    restart {
      interval = "5m"
      attempts = 4
      delay    = "30s"
      mode     = "delay"
    }

    network {
      port "myport" {
        static = 12345
      }
    }

    service {
      name = "myjobname"
      port = "myport"

      tags = ["myjobname"]

      meta {
        my_cluster_name = "myjobname"
      }

      // check {
      //   name     = "healthcheck"
      //   type     = "tcp"
      //   interval = "60s"
      //   timeout  = "10s"
      //   port     = "myport"
      // }
    } # service

    task "mytask" {
      driver = "raw_exec"

      template {
        data = <<EOH
#!/bin/bash
echo "local/config.file"
cat local/config.file
echo "Going to sleep..."
while true; do
  sleep 5
done
EOH
        destination = "local/starter.bash"
      }

      template {
        data = <<EOH
key1=val1
key2=val2

myvariable=[[range $index, $service := service "nomad" ]][[if ne $index 0]],[[end]][[$service.Address]]:[[$service.Port]][[end]]

EOH

        destination     = "local/config.file"

        left_delimiter  = "[["
        right_delimiter = "]]"
      }


      config {
        command = "/bin/bash"
        args    = ["local/starter.bash", "local/config.file"]
      }

      resources {
        cores  = 1
        memory = 128
      } # resources
    } # task
  } # group
} # job

