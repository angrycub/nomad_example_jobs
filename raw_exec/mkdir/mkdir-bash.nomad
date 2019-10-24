job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "mkdir" {
      driver = "raw_exec"
      config { 
        command = "bash" 
        args = ["-c", "rm -rf /var/log/service; mkdir -p /var/log/service/{watch,export}"]
      }
    }
  }
}
