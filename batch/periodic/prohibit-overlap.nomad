job "prohibit-overlap.nomad" {
  datacenters = ["dc1"]
  type = "batch"
  periodic {
    cron  = "* * * * *"
    prohibit_overlap = true
  }
  
  group "group" {
    task "payload" {
      driver = "exec"
      config {
        command = "bash"
        args = [ "-c","echo \"Sleeping 5 minutes...\"; sleep 300" ]
      }
    }
  }
}
