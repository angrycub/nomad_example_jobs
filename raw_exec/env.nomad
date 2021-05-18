job "env" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "env" {
      driver = "raw_exec"
      config { 
        command = "env"
        args = []
      }
    }
  }
}
