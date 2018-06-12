job "template" {
  datacenters = ["dc1"]
  type = "batch"
  group "group" {
    count = 1
    task "command" {
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

    concat key:  service/fabio/{{ env "NOMAD_JOB_NAME" }}/listeners
    key:         {{ keyOrDefault ( printf "service/fabio/%s/listeners" ( env "NOMAD_JOB_NAME" ) ) ":9999" }}

{{ define "custom" }}service/fabio/{{env "NOMAD_JOB_NAME" }}/listeners{{ end }}
    key:         {{ keyOrDefault (executeTemplate "custom") ":9999" }}

  EOH

        destination = "local/template.out"
      }
    }
  }
}
