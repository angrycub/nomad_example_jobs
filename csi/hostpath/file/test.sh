#!/bin/bash

# create the volume in the "external provider"

PLUGIN_ID=$1
VOLUME_NAME=$2

# non-dev mode
# CSI_ENDPOINT="/var/nomad/client/csi/monolith/$PLUGIN_ID/csi.sock"

# dev mode path is going to be in a tempdir
PLUGIN_DOCKER_ID=$(docker ps | grep hostpath | awk -F' +' '{print $1}')
CSI_ENDPOINT=$(docker inspect $PLUGIN_DOCKER_ID | jq -r '.[0].Mounts[] | select(.Destination == "/csi") | .Source')/csi.sock

echo "creating volume..."
UUID=$(sudo csc --endpoint $CSI_ENDPOINT controller create-volume $VOLUME_NAME --cap 1,2,ext4 | grep -o '".*"' | tr -d '"')

echo "registering volume $UUID..."

echo $(printf 'id = "%s"
name = "%s"
type = "csi"
external_id = "%s"
plugin_id = "%s"
access_mode = "single-node-writer"
attachment_mode = "file-system"' $VOLUME_NAME $VOLUME_NAME $UUID $PLUGIN_ID) > volume.hcl

nomad volume register volume.hcl

echo "querying volume $UUID..."
nomad volume status $UUID
