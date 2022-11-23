job "example" {
  datacenters = ["dc1"]

  constraint {
    distinct_hosts = true
  }

  group "cache" {
    constraint {
      attribute = "${node.class}"
      value     = "gpu"
    }

    network {
      port "db" {}
    }

    task "redis" {
      driver = "docker"
      config {
        image = "redis:7"
        ports = ["db"]
      }
    }
  }
  group "cache2" {
    network {
      port "db" {}
    }

    constraint {
      attribute = "${node.class}"
      value     = "gpu"
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:7"
        ports = ["db"]
      }
    }
  }
}
