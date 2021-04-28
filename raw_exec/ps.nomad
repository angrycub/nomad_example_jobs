job "mkdir" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "mkdir" {
      driver = "raw_exec"
      config { 
        command = "ps"
        args = ["-aef", "--forest"]
      }
    }
  }
}
