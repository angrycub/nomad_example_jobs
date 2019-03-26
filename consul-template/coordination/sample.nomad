job sleepy {
  datacenters = ["dc1"]
  group "group" {
    count = 1

## You might want to constrain this, so here's one to help
#    constraint {
#      attribute = "${attr.unique.hostname}"
#      operator  = "="
#      value     = "nomad-client-1.node.consul"
#    }
    task "sleepy.sh" {
      template {
        data = <<EOH
#!/bin/bash
{{ $consulKey := printf "nomad/jobs/%s/%s/first_task.sh/running" (env "NOMAD_JOB_NAME") (env "NOMAD_ALLOC_ID") }}{{ $consulKey }} 
#{{ key $consulKey }}

SLEEP_SECS=${SLEEP_SECS:-2} # provide default of 2 seconds
interruptable_sleep() { for i in $(seq 1 $((2*${1}))); do sleep .5; done; }
sigint() { echo "$(date) - SIGTERM received; Ending."; exit 0; }
trap 'sigint'  INT
echo "$(date) - Starting. SLEEP_SECS=${SLEEP_SECS}"
while true; do echo "$(date) - Sleeping for ${SLEEP_SECS} seconds."; interruptable_sleep ${SLEEP_SECS}; done

EOH
        destination = "local/sleepy.sh"
      }

      driver = "exec"
      config { command = "${NOMAD_TASK_DIR}/sleepy.sh" }
      resources { memory = 10 cpu = 100
      }
    }

    task "first_task.sh" {
      artifact {
        source = "https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip"
      }
      template {
        data = <<EOH
#!/bin/bash
SLEEP_SECS=${SLEEP_SECS:-2} # provide default of 2 seconds
interruptable_sleep() { for i in $(seq 1 $((2*${1}))); do sleep .5; done ;}
sigint() { echo "$(date) - SIGTERM received; Ending."; exit 0;}
trap 'sigint'  INT
echo "$(date) - Starting. Sleeping 10 seconds to simulate startup time or something"
sleep 10
chmod +x ${NOMAD_TASK_DIR}/consul
export CONSUL_HTTP_ADDR="http://127.0.0.1:8500"

# If your cluster is ACL enabled, you will need to add it here.
#export CONSUL_HTTP_TOKEN="3ef34421-1b20-e543-65d4-54067560d377"
{{ $consulKey := printf "nomad/jobs/%s/%s/%s/running" (env "NOMAD_JOB_NAME") (env "NOMAD_ALLOC_ID") (env "NOMAD_TASK_NAME") }} 
echo "Running: ${NOMAD_TASK_DIR}/consul kv put \"{{ $consulKey }}\" \"$(date)\""
${NOMAD_TASK_DIR}/consul kv put "{{ $consulKey }}" "$(date)"
while true; do echo "$(date) - Sleeping for ${SLEEP_SECS} seconds."; interruptable_sleep ${SLEEP_SECS}; done

EOH
        destination = "local/first_task.sh"
      }

      driver = "exec"
      config { command = "${NOMAD_TASK_DIR}/first_task.sh" }
      resources { memory = 10 cpu = 100
      }
    }

  }
}

