#! /bin/bash
jobs=$(nomad status | grep ing | grep -v "/periodic-" |awk '{print $1}')
echo $(echo "${jobs}" |wc -l)
for I in ${jobs}; do
  echo "Exporting $I"
  nomad inspect $I > $I.jsonjob
done
