job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    service {
      tags = ["redis", "cache"]
      port = "db"

      check {
        name     = "alive"
        type     = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }
    task "redis" {
      template {
        destination = "secrets/env"
        env         = true
        data        = <<EOH
C_HOSTNAME="foo-{{env "NOMAD_ALLOC_ID"}}-{{ env "attr.unique.hostname" }}"
EOH
      }

      driver = "docker"

      config {
        image    = "redis:7"
        ports    = ["db"]
	      hostname = "${C_HOSTNAME}"
      }
    }
  }
}
