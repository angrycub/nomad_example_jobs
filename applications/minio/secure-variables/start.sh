#! /usr/bin/env bash

mkdir -p minio-data
sed "s|«/absolute/path/to»|$(pwd)|g" volume.hcl > .volume_patch.hcl
nohup nomad agent -dev -config=.volume_patch.hcl -acl-enabled >nomad.log 2>&1 &

echo -n $! > .nomad.pid
echo "Nomad PID is $(cat .nomad.pid)"
disown

# wait for leadership
sleep 3

echo '{"BootstrapSecret": "2b778dd9-f5f1-6f29-b4b4-9a5fa948757a"}' | nomad operator api /v1/acl/bootstrap
echo ''

export NOMAD_TOKEN=2b778dd9-f5f1-6f29-b4b4-9a5fa948757a
echo -n ${NOMAD_TOKEN} > .nomad.token


nomad var put nomad/jobs/minio/storage/minio \
  root_user="AKIAIOSFODNN7EXAMPLE" \
  root_password="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

nomad job run -detach minio.nomad

echo 'export NOMAD_TOKEN=2b778dd9-f5f1-6f29-b4b4-9a5fa948757a'
