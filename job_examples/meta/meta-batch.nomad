job "example" {
  datacenters = ["dc1"]
  // because the sample payload terminates, running it as a
  // `batch` job allows for that without having to sleep loop
  type = "batch"

  meta {
    "meta_key_1" = "meta_value_1"
  }

  group "group" {
    task "task" {
      driver = "exec"
      config {
        command = "env"
      }
    }
  }
}
