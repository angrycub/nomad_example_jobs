# this job will hopefully die if the node doesn't have
# enough disk space to service the job
job "lifecycle" {
  datacenters = ["dc1"]
  type        = "service"

  group "cache" {
    # disable deployments
    update {
      max_parallel = 0
    }

    task "init-myservice" {
      driver = "docker"

      config {
        image       = "busybox:1.28"
        command     = "sh"
        dns_servers = [ "10.0.2.21" ]
        args        = ["-c", "echo -n 'Waiting for service...'; until nslookup myservice.service.consul; do echo '.'; sleep 2; done"]
      }

      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      resources {
        cpu    = 200
        memory = 128
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
