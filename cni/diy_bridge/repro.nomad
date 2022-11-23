variable "dcs" {
  type        = list(string)
  default     = ["dc1"]
  description = "Nomad datacenters in which to run the job."
}

job "example" {
  datacenters = ["dc1"]

  group "g1" {

    network {
      mode = "bridge"
      port "foo" {
        to = 1337
      }
    }

    task "nc-alpine" {
      driver = "docker"
      config {
        image = "alpine"
        args  = ["nc", "-lk", "-p", "${NOMAD_PORT_foo}", "-e", "cat"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}

