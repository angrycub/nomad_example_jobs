#! /usr/bin/env bash

for Region in global dc1
do
  echo "Stopping region \"${Region}..."
  kill $(cat .state/${Region}.pid)
done

echo "Purging test data"...
rm -rf .state
