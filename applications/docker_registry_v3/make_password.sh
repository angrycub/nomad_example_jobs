#!/bin/bash

cmd="htpasswd -Bbn $1 $2"
if ! [ -x "$(command -v htpasswd)" ]; then
  if ! [ -x "$(command -v docker)" ]; then
    echo 'Notice: this script requires htpasswd or docker.' >&2
    exit 1
  fi

  echo 'Notice: htpasswd is not installed. Using docker to run it.' >&2
  fetchedDocker=true
  cmd="docker run --rm -it -v $(pwd):/out --entrypoint="htpasswd" xmartlabs/htpasswd -Bbn $1 $2"
fi

user=$1
password=$(eval $cmd | tr -d "\n"| tr ":" " " | awk '{print $2}')

varPath="nomad/jobs/registry/docker/container"
nomad var get $varPath | nomad var put - "$user"="$password"
