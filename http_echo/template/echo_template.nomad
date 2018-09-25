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
          "$content",
          "-listen",
          ":8080",
        ]

        port_map {
          http = 8080
        }
      }

 template {
        data = <<EOH
content = "        
                 node.unique.id: {{ env "node.unique.id" }}
                node.datacenter: {{ env "node.datacenter" }}
               node.unique.name: {{ env "node.unique.name" }}
                     node.class: {{ env "node.class" }}
                  attr.cpu.arch: {{ env "attr.cpu.arch" }}
              attr.cpu.numcores: {{ env "attr.cpu.numcores" }}
          attr.cpu.totalcompute: {{ env "attr.cpu.totalcompute" }}
         attr.consul.datacenter: {{ env "attr.consul.datacenter" }}
           attr.unique.hostname: {{ env "attr.unique.hostname" }}
 attr.unique.network.ip-address: {{ env "attr.unique.network.ip-address" }}
               attr.kernel.name: {{ env "attr.kernel.name" }}
            attr.kernel.version: {{ env "attr.kernel.version" }}
       attr.platform.aws.ami-id: {{ env "attr.platform.aws.ami-id" }}
attr.platform.aws.instance-type: {{ env "attr.platform.aws.instance-type" }}
                   attr.os.name: {{ env "attr.os.name" }}
                attr.os.version: {{ env "attr.os.version" }}

                NOMAD_ALLOC_DIR: {{env "NOMAD_ALLOC_DIR"}}
                 NOMAD_TASK_DIR: {{env "NOMAD_TASK_DIR"}}
              NOMAD_SECRETS_DIR: {{env "NOMAD_SECRETS_DIR"}}
             NOMAD_MEMORY_LIMIT: {{env "NOMAD_MEMORY_LIMIT"}}
                NOMAD_CPU_LIMIT: {{env "NOMAD_CPU_LIMIT"}}
                 NOMAD_ALLOC_ID: {{env "NOMAD_ALLOC_ID"}}
               NOMAD_ALLOC_NAME: {{env "NOMAD_ALLOC_NAME"}}
              NOMAD_ALLOC_INDEX: {{env "NOMAD_ALLOC_INDEX"}}
                NOMAD_TASK_NAME: {{env "NOMAD_TASK_NAME"}}
               NOMAD_GROUP_NAME: {{env "NOMAD_GROUP_NAME"}}
                 NOMAD_JOB_NAME: {{env "NOMAD_JOB_NAME"}}
                       NOMAD_DC: {{env "NOMAD_DC"}}
                   NOMAD_REGION: {{env "NOMAD_REGION"}}
                    VAULT_TOKEN: {{env "VAULT_TOKEN"}}

                     GOMAXPROCS: {{env "GOMAXPROCS"}}
                           HOME: {{env "HOME"}}
                           LANG: {{env "LANG"}}
                        LOGNAME: {{env "LOGNAME"}}
              NOMAD_ADDR_export: {{env "NOMAD_ADDR_export"}}
              NOMAD_ADDR_exstat: {{env "NOMAD_ADDR_exstat"}}
                NOMAD_ALLOC_DIR: {{env "NOMAD_ALLOC_DIR"}}
                 NOMAD_ALLOC_ID: {{env "NOMAD_ALLOC_ID"}}
              NOMAD_ALLOC_INDEX: {{env "NOMAD_ALLOC_INDEX"}}
               NOMAD_ALLOC_NAME: {{env "NOMAD_ALLOC_NAME"}}
                NOMAD_CPU_LIMIT: {{env "NOMAD_CPU_LIMIT"}}
                       NOMAD_DC: {{env "NOMAD_DC"}}
               NOMAD_GROUP_NAME: {{env "NOMAD_GROUP_NAME"}}
         NOMAD_HOST_PORT_export: {{env "NOMAD_HOST_PORT_export"}}
         NOMAD_HOST_PORT_exstat: {{env "NOMAD_HOST_PORT_exstat"}}
                NOMAD_IP_export: {{env "NOMAD_IP_export"}}
                NOMAD_IP_exstat: {{env "NOMAD_IP_exstat"}}
                 NOMAD_JOB_NAME: {{env "NOMAD_JOB_NAME"}}
             NOMAD_MEMORY_LIMIT: {{env "NOMAD_MEMORY_LIMIT"}}
              NOMAD_PORT_export: {{env "NOMAD_PORT_export"}}
              NOMAD_PORT_exstat: {{env "NOMAD_PORT_exstat"}}
                   NOMAD_REGION: {{env "NOMAD_REGION"}}
              NOMAD_SECRETS_DIR: {{env "NOMAD_SECRETS_DIR"}}
                 NOMAD_TASK_DIR: {{env "NOMAD_TASK_DIR"}}
                NOMAD_TASK_NAME: {{env "NOMAD_TASK_NAME"}}
                           PATH: {{env "PATH"}}
                            PWD: {{env "PWD"}}
                          SHELL: {{env "SHELL"}}
                          SHLVL: {{env "SHLVL"}}
                           USER: {{env "USER"}}
                    VAULT_TOKEN: {{env "VAULT_TOKEN"}}
                           
   concat key:  service/fabio/{{ env "NOMAD_JOB_NAME" }}/listeners
    key:         {{ keyOrDefault ( printf "service/fabio/%s/listeners" ( env "NOMAD_JOB_NAME" ) ) ":9999" }}

{{ define "custom" }}service/fabio/{{env "NOMAD_JOB_NAME" }}/listeners{{ end }}
    key:         {{ keyOrDefault (executeTemplate "custom") ":9999" }}

   math - alloc_id + 1: {{env "NOMAD_ALLOC_INDEX" | parseInt | add 1}}


"
  EOH

        destination = "local/template.out"
        env = true
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
