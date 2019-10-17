job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "env-output" {
      resources { network { port "sample" {} } }
      driver = "raw_exec"
      config { command = "env" }
    }
    task "date-output" {
      resources { network { port "sample" {} } }
      driver = "raw_exec"
      config { command = "date" }
    }
    task "template" {
      resources { network { port "export" {} port "exstat" { static=8080 } } }
      driver = "raw_exec"
      config {
        command = "bash"
        args = ["-c", "cat local/template.out"]
      }
      template {
        data = <<EOH
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

              NOMAD_ADDR_export: {{env "NOMAD_ADDR_export"}}
              NOMAD_ADDR_exstat: {{env "NOMAD_ADDR_exstat"}}
         NOMAD_HOST_PORT_export: {{env "NOMAD_HOST_PORT_export"}}
         NOMAD_HOST_PORT_exstat: {{env "NOMAD_HOST_PORT_exstat"}}
                NOMAD_IP_export: {{env "NOMAD_IP_export"}}
                NOMAD_IP_exstat: {{env "NOMAD_IP_exstat"}}
              NOMAD_PORT_export: {{env "NOMAD_PORT_export"}}
              NOMAD_PORT_exstat: {{env "NOMAD_PORT_exstat"}}
                     GOMAXPROCS: {{env "GOMAXPROCS"}}
                           HOME: {{env "HOME"}}
                           LANG: {{env "LANG"}}
                        LOGNAME: {{env "LOGNAME"}}
                           PATH: {{env "PATH"}}
                            PWD: {{env "PWD"}}
                          SHELL: {{env "SHELL"}}
                          SHLVL: {{env "SHLVL"}}
                           USER: {{env "USER"}}

Further Consul Template Magic:

Math
  math - alloc_id + 1: {{env "NOMAD_ALLOC_INDEX" | parseInt | add 1}}

Composition using inline templates

  {{- define "custom" }}NOMAD_ADDR_{{"date-output" | replaceAll "-" "_" }}_sample{{ end }}
  {{ executeTemplate "custom" }}: {{ env (executeTemplate "custom") }}

Composition using printf
  {{ $envKey := printf "NOMAD_ADDR_%s_%s" ("date-output" | replaceAll "-" "_" ) "sample" }}
  {{ $envKey }}: {{ env $envKey }}

EOH

        destination = "local/template.out"
      }
    }
  }
}
