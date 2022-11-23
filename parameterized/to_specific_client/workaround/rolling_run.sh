#!/bin/bash


ClientNodeIds=$(nomad node status -t '{{ range  .}}{{printf "%s\n" .ID}}{{end}}')

RunOutput=$(nomad job run -var node_id=f7bc1f2d-34b1-eaf8-b7d3-253f2e7de4d6 example.nomad)
AllocId=$(echo "$RunOutput" | awk '/Allocation/{ print $2}'| tr -d "\" \t")
if [ "$AllocId" == "" ]
then
	echo "No allocation found"
	exit 1
fi

FullAllocId=$(nomad alloc status -verbose $AllocId | grep -e '^ID' | awk '{print $3}')

ExitCode=./watch.py $FullAllocId

if [ $ExitCode -ne 0 ]
then
	echo "Bailing out because of an error..."
	exit 2
fi

