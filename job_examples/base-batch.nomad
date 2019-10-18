job "example" {
  datacenters = ["dc1"]
  // because the sample payload terminates, running it as a
  // `batch` job allows for that without having to sleep loop
  type = "batch"
  group "group" {
    task "task" {
      driver = "exec"
      config {
        command = "env"
      }
    }
  }
}
