job "rolling-upgrade-test" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "1m"
    health_check     = "task_states"
  }

  group "zookeeper" {
    restart {
      attempts = 2
      delay    = "15s"
      interval = "1m"
      mode     = "delay"
    }

    count = 3
    task "redis" {
      driver = "docker"
      config {
        image = "redis:3.2"
      }
    }
  }
}

