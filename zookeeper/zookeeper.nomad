job "zk" {
  datacenters = ["dc1"]
  type = "service"
  group "node" {
    count = 3
    task "zookeeper" {
      driver = "docker"

      config {
        image = "zookeeper:3.4"
        port_map {
          clientPort = 2181
          followerPort = 2888
          leaderPort = 3888
        }
      }
      template {
      env = true
      destination = "secrets/file.env"
      data = <<EOH
      MY_ZOO_ID = {{ env "NOMAD_ALLOC_INDEX | parseInt | add 1}}
      MY_ZOO_TAG = "zk{{ env "MY_ZOO_ID"}}"
      EOH
      }
      env {
        ZOO_SERVERS = "server.1=zk1.zookeyper.service.consul:2888:3888 server.1=zk2.zookeyper.service.consul:2888:3888 server.3=zk3.zookeyper.service.consul:2888:3888 ""
      }
      resources {
        cpu    = 500
        memory = 256
        network {
          port "clientPort" {}
          port "followerPort" {}
          port "electionPort" {}
        }
      }

      service {
        name = ${MY_ZOO_TAG}
        tags = []
        port = "clientPort"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
      service {
        name = "zookeeper"
        tags = ["client"]
        port = "clientPort"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
      service {
        name = "zookeeper"
        tags = ["follower"]
        port = "followerPort"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        } 
      }
      service {
        name = "zookeeper"
        tags = ["election"]
        port = "electionPort"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        } 
      }
    }
  }
}
