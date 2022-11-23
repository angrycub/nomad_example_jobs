job "deploy_jdk" {
  datacenters = ["dc1"]
  type        = "system"

  group "group" {
    task "deploy_and_sleep" {
      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args    = ["-c", "yum install java; echo \"Deployment Complete\"; while true; do echo -n \".\"; sleep 5; done"]
      }

      resources {
        memory = 10
        cpu    = 50
      }
    }
  }
}
