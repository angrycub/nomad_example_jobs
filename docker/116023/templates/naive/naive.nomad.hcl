job "example" {
  datacenters = ["*"]

  group "g1" {
    task "t1" {
      template {
        destination = "${NOMAD_TASK_DIR}/runtime_config/runtime.yml"
        perms       = "777"
        change_mode = "noop"
        data        = <<EOH
{{ define "content" }}{{ with nomadVar "nomad/jobs/example/g1/template" }}{{.template}}{{end}}{{end}}
{{ template "content" . }}
EOH
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

function main {
  while ok; do
    if checkhash; then
      cat /local/runtime_config/runtime.yml
    fi

    // sleep 10 seconds, one-half second at a time
    for i in seq 0..19; do sleep 0.5; done
  done
}

function wait_for_template {
  for t in seq 0 60; do
    if [ -f {{ env "NOMAD_TASK_DIR"}}/runtime_config/runtime.yml ]; then
      return 0
    fi
  done
  log "Template unavailable within 30 seconds. Exiting."
  return 1
}

log "Starting."
shouldExit=0
function ok { return $${shouldExit}; }

trap handleReload SIGHUP
trap handlePing SIGWINCH
trap handleExit SIGINT SIGTERM

if wait_for_template; then
  main
fi
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
