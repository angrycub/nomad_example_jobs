job "http-echo" {
  datacenters = ["dc1"]
  type        = "service"

  update {
    max_parallel = 1
  }

  group "web" {
    constraint {
      distinct_hosts = true
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "http-echo" {
      driver = "docker"

      config {
        image = "hashicorp/http-echo"

        args = [
          "-text",
          "${content}",
          "-listen",
          ":8080",
        ]

        port_map {
          http = 8080
        }
      }

 template {
        data = <<EOH
content='<table><tr><td>node.unique.id</td><td>{{ env "node.unique.id" }}</td></tr><tr><td>node.datacenter</td><td>{{ env "node.datacenter" }}</td></tr><tr><td>node.unique.name</td><td>{{ env "node.unique.name" }}</td></tr><tr><td>node.class</td><td>{{ env "node.class" }}</td></tr><tr><td>attr.cpu.arch</td><td>{{ env "attr.cpu.arch" }}</td></tr><tr><td>attr.cpu.numcores</td><td>{{ env "attr.cpu.numcores" }}</td></tr><tr><td>attr.cpu.totalcompute</td><td>{{ env "attr.cpu.totalcompute" }}</td></tr><tr><td>attr.consul.datacenter</td><td>{{ env "attr.consul.datacenter" }}</td></tr><tr><td>attr.unique.hostname</td><td>{{ env "attr.unique.hostname" }}</td></tr><tr><td>attr.unique.network.ip-address</td><td>{{ env "attr.unique.network.ip-address" }}</td></tr><tr><td>attr.kernel.name</td><td>{{ env "attr.kernel.name" }}</td></tr><tr><td>attr.kernel.version</td><td>{{ env "attr.kernel.version" }}</td></tr><tr><td>attr.platform.aws.ami-id</td><td>{{ env "attr.platform.aws.ami-id" }}</td></tr><tr><td>attr.platform.aws.instance-type</td><td>{{ env "attr.platform.aws.instance-type" }}</td></tr><tr><td>attr.os.name</td><td>{{ env "attr.os.name" }}</td></tr><tr><td>attr.os.version</td><td>{{ env "attr.os.version" }}</td></tr><tr><td>NOMAD_ALLOC_DIR</td><td>{{env "NOMAD_ALLOC_DIR"}}</td></tr><tr><td>NOMAD_TASK_DIR</td><td>{{env "NOMAD_TASK_DIR"}}</td></tr><tr><td>NOMAD_SECRETS_DIR</td><td>{{env "NOMAD_SECRETS_DIR"}}</td></tr><tr><td>NOMAD_MEMORY_LIMIT</td><td>{{env "NOMAD_MEMORY_LIMIT"}}</td></tr><tr><td>NOMAD_CPU_LIMIT</td><td>{{env "NOMAD_CPU_LIMIT"}}</td></tr><tr><td>NOMAD_ALLOC_ID</td><td>{{env "NOMAD_ALLOC_ID"}}</td></tr><tr><td>NOMAD_ALLOC_NAME</td><td>{{env "NOMAD_ALLOC_NAME"}}</td></tr><tr><td>NOMAD_ALLOC_INDEX</td><td>{{env "NOMAD_ALLOC_INDEX"}}</td></tr><tr><td>NOMAD_TASK_NAME</td><td>{{env "NOMAD_TASK_NAME"}}</td></tr><tr><td>NOMAD_GROUP_NAME</td><td>{{env "NOMAD_GROUP_NAME"}}</td></tr><tr><td>NOMAD_JOB_NAME</td><td>{{env "NOMAD_JOB_NAME"}}</td></tr><tr><td>NOMAD_DC</td><td>{{env "NOMAD_DC"}}</td></tr><tr><td>NOMAD_REGION</td><td>{{env "NOMAD_REGION"}}</td></tr><tr><td>VAULT_TOKEN</td><td>{{env "VAULT_TOKEN"}}</td></tr><tr><td>GOMAXPROCS</td><td>{{env "GOMAXPROCS"}}</td></tr><tr><td>HOME</td><td>{{env "HOME"}}</td></tr><tr><td>LANG</td><td>{{env "LANG"}}</td></tr><tr><td>LOGNAME</td><td>{{env "LOGNAME"}}</td></tr><tr><td>NOMAD_ADDR_export</td><td>{{env "NOMAD_ADDR_export"}}</td></tr><tr><td>NOMAD_ADDR_exstat</td><td>{{env "NOMAD_ADDR_exstat"}}</td></tr><tr><td>NOMAD_ALLOC_DIR</td><td>{{env "NOMAD_ALLOC_DIR"}}</td></tr><tr><td>NOMAD_ALLOC_ID</td><td>{{env "NOMAD_ALLOC_ID"}}</td></tr><tr><td>NOMAD_ALLOC_INDEX</td><td>{{env "NOMAD_ALLOC_INDEX"}}</td></tr><tr><td>NOMAD_ALLOC_NAME</td><td>{{env "NOMAD_ALLOC_NAME"}}</td></tr><tr><td>NOMAD_CPU_LIMIT</td><td>{{env "NOMAD_CPU_LIMIT"}}</td></tr><tr><td>NOMAD_DC</td><td>{{env "NOMAD_DC"}}</td></tr><tr><td>NOMAD_GROUP_NAME</td><td>{{env "NOMAD_GROUP_NAME"}}</td></tr><tr><td>NOMAD_HOST_PORT_export</td><td>{{env "NOMAD_HOST_PORT_export"}}</td></tr><tr><td>NOMAD_HOST_PORT_exstat</td><td>{{env "NOMAD_HOST_PORT_exstat"}}</td></tr><tr><td>NOMAD_IP_export</td><td>{{env "NOMAD_IP_export"}}</td></tr><tr><td>NOMAD_IP_exstat</td><td>{{env "NOMAD_IP_exstat"}}</td></tr><tr><td>NOMAD_JOB_NAME</td><td>{{env "NOMAD_JOB_NAME"}}</td></tr><tr><td>NOMAD_MEMORY_LIMIT</td><td>{{env "NOMAD_MEMORY_LIMIT"}}</td></tr><tr><td>NOMAD_PORT_export</td><td>{{env "NOMAD_PORT_export"}}</td></tr><tr><td>NOMAD_PORT_exstat</td><td>{{env "NOMAD_PORT_exstat"}}</td></tr><tr><td>NOMAD_REGION</td><td>{{env "NOMAD_REGION"}}</td></tr><tr><td>NOMAD_SECRETS_DIR</td><td>{{env "NOMAD_SECRETS_DIR"}}</td></tr><tr><td>NOMAD_TASK_DIR</td><td>{{env "NOMAD_TASK_DIR"}}</td></tr><tr><td>NOMAD_TASK_NAME</td><td>{{env "NOMAD_TASK_NAME"}}</td></tr><tr><td>PATH</td><td>{{env "PATH"}}</td></tr><tr><td>PWD</td><td>{{env "PWD"}}</td></tr><tr><td>SHELL</td><td>{{env "SHELL"}}</td></tr><tr><td>SHLVL</td><td>{{env "SHLVL"}}</td></tr><tr><td>USER</td><td>{{env "USER"}}</td></tr><tr><td>VAULT_TOKEN</td><td>{{env "VAULT_TOKEN"}}</td></tr></table>'  
EOH

        destination = "local/template.out"
        env=true
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB

        network {
          mbits = 10

          port "http" {
            static = 8080
          }
        }
      }

      service {
        name = "http-echo"

        port = "http"

        check {
          name     = "alive"
          type     = "http"
          interval = "10s"
          timeout  = "2s"
          path     = "/"
        }
      }
    }
  }
}
