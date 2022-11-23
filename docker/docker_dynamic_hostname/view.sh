#!/usr/bin/env bash

function getJobAllocIds {
  nomad alloc status -t '{{range $A := . }}{{if eq "example" .JobID}}{{printf "%s%s%s\n" .ID "|" .NodeName }}{{end}}{{end}}'
}


res_file=$(mktemp)
printf "Allocation ID\tNode Name (Nomad)\tHostname (Docker)\n" > "$res_file"

for ALLOC_INFO in $(getJobAllocIds example)
do
NODENAME=${ALLOC_INFO##*|}
ALLOC_ID=${ALLOC_INFO%%|*}
DOCKERNAME=$(nomad alloc exec ${ALLOC_ID} cat /etc/hostname)
printf "%s\t%s\t%s\n" $ALLOC_ID $NODENAME $DOCKERNAME >> "$res_file"
done 

column -t -s"$(printf "\t")" $res_file
rm -rf "$res_file"
