#! /bin/bash

if [ -z "$1" ] 
then
  SLEEP_SECS="2"
else
  SLEEP_SECS="$1"
fi

if [ -z "${EXTRAS}" ]
then
  ep=""
else 
  ep="EXTRAS: [${EXTRAS}]"
fi 

echo "$(date) -- Starting SleepyEcho. Sleep interval is ${SLEEP_SECS} sec. ${ep}"

while true
do 
  echo "$(date) -- Alive... going back to sleep for ${SLEEP_SECS}.  ${ep}"
  sleep ${SLEEP_SECS}
done
