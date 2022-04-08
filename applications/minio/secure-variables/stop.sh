#! /usr/bin/env bash

PID=$(cat .nomad.pid)
echo "Stopping Nomad (pid: ${PID})"
rm -rf .nomad.pid
rm -rf .nomad.token
rm -rf .volume_patch.hcl
rm -rf nomad.log
rm -rf minio_data
echo "Done."