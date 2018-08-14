job "rolling-upgrade-test" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "1m"
    health_check     = "task_states"
  }

  group "zookeeper-1" {
    restart {
      attempts = 2
      delay    = "15s"
      interval = "1m"
      mode     = "delay"
    }

    ephemeral_disk {
      migrate = true
      size    = "300"
      sticky  = true
    }

    count = 1
    task "zookeeper-1" {
      driver = "docker"
      config {
        image = "redis:4.0"
      }
    }
  }

  group "zookeeper-2" {
    restart {
      attempts = 2
      delay    = "15s"
      interval = "1m"
      mode     = "delay"
    }

    ephemeral_disk {
      migrate = true
      size    = "300"
      sticky  = true
    }

    count = 1
    task "zookeeper-2" {
      driver = "docker"
      config {
        image = "redis:4.0"
      }
    }
  }

  group "zookeeper-3" {
    restart {
      attempts = 2
      delay    = "15s"
      interval = "1m"
      mode     = "delay"
    }

    ephemeral_disk {
      migrate = true
      size    = "300"
      sticky  = true
    }

    count = 1
    task "zookeeper-3" {
      driver = "docker"
      config {
        image = "redis:4.0"
      }
    }
  }
}

