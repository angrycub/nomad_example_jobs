job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {}
    }
    volume "test" {
      type      = "host"
      source    = "container-test"
      read_only = false
    }

    task "mount" {
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }
      driver = "exec"
      volume_mount {
        volume      = "test"
        destination = "alloc/host_vol"
      }
      config {
        command = "/bin/bash"
        args    = ["-c", "while true; do sleep 300; done"]
      }
      resources {
        cpu    = 20
        memory = 100
      }
    }
    task "redis" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["db"]
        mounts = [
          {
            type     = "bind"
            target   = "/folder1"
            source   = "${NOMAD_ALLOC_DIR}/host_vol/folder1"
            readonly = false
            bind_options = {
              propagation = "rshared"
            }
          }
        ]
      }
      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
