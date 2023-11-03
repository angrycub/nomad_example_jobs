job "example" {
  datacenters = ["*"]

  group "g1" {

    # This cheat enables us to fetch a template from a Nomad Variable and then
    # render it properly in the main task. For someone using terraform to
    # generate the files, they could write the template data to anyplace that
    # can be served by go-getter: git, mercurial, s3, simple URLs, etc.

    task "init_tpl" {
      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      template {
        data = <<EOH
{{ with nomadVar "nomad/jobs/example/g1/template_sidecar" }}{{.template}}{{end}}
      EOH

        destination = "${NOMAD_ALLOC_DIR}/config.tpl"
        perms       = "777"
        change_mode = "noop"
      }

      driver = "docker"
      config {
        image      = "alpine"
        entrypoint = ["/bin/sh"]
        args       = ["-c", "exit 0"]
      }
    }

    task "t1" {
      meta = {
        environment = "dev"
      }

      template {
        source      = "${NOMAD_ALLOC_DIR}/config.tpl"
        destination = "${NOMAD_TASK_DIR}/runtime_config/runtime.yml"
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
