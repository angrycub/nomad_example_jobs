job "quoted" {
  datacenters = ["dc1"]
  type = "service"
  group "group" {
    count = 1
    task "payload" {
      driver = "exec"
      config { 
        command = "bash" 
        args = ["-c", "bash -c \"tail -f /dev/null\""]
      }
    }
  }
}
