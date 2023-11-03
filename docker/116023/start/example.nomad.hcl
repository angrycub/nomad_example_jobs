job "example" {
  datacenters = ["*"]

  group "g1" {
    task "t1" {
      template {
        data = <<EOH
overrides:
  fake:
# set limits based off environment
{{ if eq "dev" (env "NOMAD_META_environment") }}
    ingestion_rate: 150000
    ingestion_burst_size: 1550000
    ingester_limits:
    max_inflight_push_requests: 30000
    max_ingestion_rate: 100000
    max_series: 1250000
    max_tenants: 1
{{ else }}
    ingestion_rate: 200000
    ingestion_burst_size: 2500000
{{ end }}

distributor_limits:
  max_ingestion_rate: 75000
  max_inflight_push_requests: 1500
  max_inflight_push_requests_bytes: 314572800
      EOH

        destination = "local/runtime_config/runtime.yml"
        perms       = "777"
        change_mode = "noop"
      }
      template {
        data = <<EOH
#!/bin/sh

function log {
  echo "$(date) - $${1}"
}

function checkhash {
  local runhash=""
  if [ -f /tmp/runhash ]; then
    runhash="$(cat /tmp/runhash)"
  fi
  newhash="$(md5sum /local/runtime_config/runtime.yml)"
  if [ "$${newhash}" != "$${runhash}" ]; then
    log "Updated configuration."
    printf "$${newhash}" > /tmp/runhash
    return 0
  fi
  return 1
}

function handleReload {
  log "Got reload signal; reloading configuration."
  rm -rf /tmp/runhash
}

function handleExit {
  log "Got exit signal; quitting."
  shouldExit=1
}

function handlePing {
  log "Got ping signal (SIGWINCH); *pong*"
}

function cleanup {
  rm -rf /tmp/runhash
  log "Done."
}

log "Starting."
shouldExit=0
function ok { return $${shouldExit}; }

trap handleReload SIGHUP
trap handlePing SIGWINCH
trap handleExit SIGINT SIGTERM

while ok; do
  if checkhash; then
    cat /local/runtime_config/runtime.yml
  fi

  // sleep 10 seconds, one-half second at a time
  for i in seq 0..19; do sleep 0.5; done
done

cleanup
EOH
        destination = "local/job.sh"
        perms       = "777"
        change_mode = "noop"
      }

      driver = "docker"
      config {
        image = "alpine"
        entrypoint = ["local/job.sh"]
      }
    }
  }
}
