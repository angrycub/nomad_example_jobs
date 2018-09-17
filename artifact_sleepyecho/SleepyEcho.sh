#! /bin/bash

if [ -z "$1" ] 
then
  SLEEP_SECS="2"
else
  SLEEP_SECS="$1"
fi

if [ -z "${EXTRAS}" ]
then
  extras_part=""
else 
  extras_part="EXTRAS: [${EXTRAS}]"
fi 

echo "$(date) -- Starting SleepyEcho. Sleep interval is ${SLEEP_SECS} sec. ${extras_part}"

if [ ! -f "/alloc/data/time.txt" ] 
then
  echo "$(date) -- Writing date to /alloc/data/time.txt"
  echo -n "$(date)" > /alloc/data/time.txt
else
  echo "$(date) -- Found time.txt file in /alloc/data -- $(cat /alloc/data/time.txt)"
fi

while true
do 
  echo "$(date) -- Alive... going back to sleep for ${SLEEP_SECS}.  ${extras_part}"
  sleep ${SLEEP_SECS}
done
