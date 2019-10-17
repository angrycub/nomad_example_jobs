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

    task "sleepy-bash" {
template {
  data = <<EOH
{{ with secret "pki_int/issue/example-dot-com" "common_name=test.example.com" "ttl=24h" "ip_sans=127.0.0.1" }}
{{- .Data.certificate -}}
{{ end }}
EOH
  destination   = "${NOMAD_SECRETS_DIR}/certificate.crt"
  change_mode   = "restart"
}

template {
  data = <<EOH
{{ with secret "pki_int/issue/example-dot-com" "common_name=test.example.com" "ttl=24h" "ip_sans=127.0.0.1" }}
{{- .Data.issuing_ca -}}
{{ end }}
EOH
  destination   = "${NOMAD_SECRETS_DIR}/ca.crt"
  change_mode   = "restart"
}

template {
  data = <<EOH
{{ with secret "pki_int/issue/example-dot-com" "common_name=test.example.com" "ttl=24h" "ip_sans=127.0.0.1" }}
{{- .Data.private_key -}}
{{ end }}
EOH
  destination   = "${NOMAD_SECRETS_DIR}/private_key.key"
  change_mode   = "restart"
}


      template {
        data = <<EOH
#!/bin/bash

echo "$(date) -- Starting sleepy."
echo "$(date) -- ${NOMAD_SECRETS_DIR}/certificate.crt"
cat ${NOMAD_SECRETS_DIR}/certificate.crt
echo "$(date) -- ${NOMAD_SECRETS_DIR}/ca.crt"
cat ${NOMAD_SECRETS_DIR}/ca.crt
echo "$(date) -- ${NOMAD_SECRETS_DIR}/private_key.key"
cat ${NOMAD_SECRETS_DIR}/private_key.key
echo "$(date) -- Going to sleep forever. Stop the job via Nomad when you would like."
while true
do 
  sleep 5
done
EOH
        destination = "local/sleepy.sh"
      }

      driver = "exec"

      config {
        command = "${NOMAD_TASK_DIR}/sleepy.sh"
      }
      
      vault {
        policies = ["nomad-client"]
        change_mode   = "signal"
        change_signal = "SIGUSR1"
      }

      resources {
        memory = 10
        cpu = 50
      }
    }
  }
}

