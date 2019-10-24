job "mkdir" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "mkdir" {
      driver = "raw_exec"
      config { 
        command = "mkdir"
        # This will create a directory named `/var/log/service/{watch,export}`
        # which is probably not what you want. 
        args = ["-p", "/var/log/service/{watch,export}"]
      }
    }
  }
}
