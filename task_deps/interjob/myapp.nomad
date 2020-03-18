ijob "myapp" {
  datacenters = ["dc1"]
  type        = "service"

  group "myapp" {
    # disable deployments
    update {
      max_parallel = 0
    }

    task "await-myservice" {
      driver = "docker"

      config {
        image       = "busybox:1.28"
        command     = "sh"
        args        = ["-c", "echo -n 'Waiting for service'; until nslookup myservice.service.consul 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "myapp-container" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The app is running! && sleep 3600"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}

