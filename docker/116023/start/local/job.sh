#!/bin/sh

function log {
  echo "$(date) - ${1}"
}

function checkhash {
  local runhash=""
  if [ -f /tmp/runhash ]; then
    runhash="$(cat /tmp/runhash)"
  fi
  newhash="$(md5sum /local/runtime_config/runtime.yml)"
  if [ "${newhash}" != "${runhash}" ]; then
    echo "$(date) - Updated configuration."
    printf "${newhash}" > /tmp/runhash
    echo $runhash
    echo $newhash
    echo "$(cat /tmp/runhash)"
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

function cleanup {
  rm -rf /tmp/runhash
  log "Done."
}

log "Starting."

shouldExit=0
function ok { return $shouldExit; }

trap handleReload SIGHUP
trap handleExit SIGINT SIGTERM

while ok; do
  if checkhash; then 
    cat /local/runtime_config/runtime.yml
  fi
  for i in seq 0..19; do
    sleep 0.5
  done
done

cleanup

