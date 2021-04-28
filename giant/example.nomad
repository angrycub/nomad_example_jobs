job "giant" {
  datacenters = ["dc1"]

  group "mysql" {
    volume "mysql" { type="host"  source = "mysql"  }
    ephemeral_disk {
      migrate = false
      size    = "2000"
      sticky  = true
    }
    task "ls" {
      driver = "exec"
      volume_mount { volume="mysql" destination="/var/lib/mysql" }
      config {
	command="bash"
        args=["-c", "while true; do ls /var/lib/mysql; sleep 60; done"]
      }

      resources {
        cpu=100 memory=128  
      }
    }
  }
}
