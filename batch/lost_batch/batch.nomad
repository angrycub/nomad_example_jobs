job "example" {
  datacenters = ["dc1"]
  type = "batch"
  group "sleepers" {
    count = 1 
    restart { mode="fail" attempts=0 }
    reschedule { attempts=0 unlimited=false }
    task "wait" {
      driver = "raw_exec"
      config {
        command = "bash"
        args = [
          "-c",
          "echo Starting; sleep=300; echo Sleeping $sleep seconds.; sleep $sleep; echo Done; exit 0"
        ]
      }
    }
  }
}
