#! /bin/bash

jobs=$(ls *.jsonjob)

for I in ${jobs}; do
  echo "Jamming $I"
  curl -X PUT -d @$I http://127.0.0.1:4646/v1/jobs
  echo ""
done
