job "example" {
  datacenters = ["dc1"]
  type = "service"
  group "cache" {
    count = 1
    task "redis" {
      artifact {
	source = "https://angrycub-hc.s3.amazonaws.com/public/folder.tgz"
        destination = "local/folder"
      }
      driver = "exec"
      config {
        command = "bash"
        args = ["-c", "echo Starting up and sleeping...;sleep 1000"]
      }
    }
  }
}
