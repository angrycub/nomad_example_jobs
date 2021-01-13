# For ACL-enabled Consul Clusters, you need to specify a Consul ACL token down
# in the `fabio-linux-amd64` task's env stanza. Uncomment the example and
# replace the token with a valid Consul ACL token.

job "fabio" {
  datacenters = ["dc1"]
  type = "system"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "fabio-linux-amd64" {
    network {
      port "http" {
        static = "9999"
      }

      port "ui" {
        static = "9998"
      }
    }

    task "fabio-linux-amd64" {
      constraint {
        attribute = "${attr.cpu.arch}"
        operator  = "="
        value     = "amd64"
      }

      constraint {
        attribute = "${attr.kernel.name}"
        operator  = "="
        value     = "linux"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.15/fabio-1.5.15-go1.15.5-linux_amd64"
        options {
          checksum = "sha256:14c7a02ca95fb00a4f3010eab4e3c0e354a3f4953d2a793cb800332012f42066"
        }
      }

      driver = "exec"

      config {
        command = "fabio-1.5.15-go1.15.5-linux_amd64"
      }

      env {
#        FABIO_REGISTRY_CONSUL_TOKEN = "c62d8564-c0c5-8dfe-3e75-005debbd0e40"
      }

      resources {
        cpu = 200
        memory = 32
      }
    }
  }
}

