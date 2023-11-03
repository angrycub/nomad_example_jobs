variable "dcs" {
  type = list(string)
  default = ["dc1"]
  description = "datacenters in which to run the job."
}

job "j1" {
  datacenters = var.dcs

  group "nomad" {
    task "servers" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sleep"
        args    = ["infinity"]
      }
    }
  }
}