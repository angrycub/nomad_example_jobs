# this job will hopefully die if the node doesn't have
# enough disk space to service the job
job "lifecycle" {
  datacenters = ["dc1"]
  type        = "service"

  group "myservice" {
    task "myservice" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The service is running! && while true; do sleep 2; done"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }

  group "cache" {
    # disable deployments
    update {
      max_parallel = 0
    }

    task "init-myservice" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo -n 'Waiting for service...'; until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo -n '.'; sleep 2; done"]
      }
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }

    task "init-mydb" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"]
      }

      lifecycle {
        hook = "prestart"
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
