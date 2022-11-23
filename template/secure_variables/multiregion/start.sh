#! /usr/bin/env bash

echo "📝 Creating configuration"
for Region in global dc1
do
  echo " - \"${Region}\""
  for Dir in config data log
  do 
    mkdir -p .state/${Dir}.${Region}
  done
  echo "log_file = \"$(pwd)/.state/log.${Region}/\"" > .state/config.${Region}/logging.hcl
  echo 'log_level = "DEBUG"' >> .state/config.${Region}/logging.hcl
  echo "data_dir = \"$(pwd)/.state/data.${Region}/\"" > .state/config.${Region}/data_dir.hcl
  echo "name   = \"test_${Region}\"" > .state/config.${Region}/name.hcl
  echo "region = \"${Region}\"" >> .state/config.${Region}/name.hcl
done
echo ""

I=1
for Region in global dc1
do
  echo "server { enabled=true bootstrap_expect=1 }" > .state/config.${Region}/server.hcl
  echo "client { enabled=true }" > .state/config.${Region}/client.hcl
  echo "plugin \"raw_exec\" { config { enabled = true }}"  > .state/config.${Region}/raw_exec.hcl
  echo "addresses {" > .state/config.${Region}/address.hcl
  echo "advertise {" > .state/config.${Region}/advertise.hcl
  echo "ports {" > .state/config.${Region}/ports.hcl
  P=6
  for Proto in http rpc serf
  do
    echo "  ${Proto} = \"127.0.0.1\"" >> .state/config.${Region}/address.hcl
    echo "  ${Proto} = \"${I}464${P}\"" >> .state/config.${Region}/ports.hcl
    echo "  ${Proto} = \"127.0.0.1:${I}464${P}\"" >> .state/config.${Region}/advertise.hcl
    P=$((P+1))
  done
  echo "}" >> .state/config.${Region}/address.hcl
  echo "}" >> .state/config.${Region}/advertise.hcl
  echo "}" >> .state/config.${Region}/ports.hcl
  I=$((I+1))
done
echo ""

echo "🚀 Starting clusters..."
for Region in global dc1
do
    echo " - \"${Region}\""
    nomad agent -config=$(pwd)/.state/config.${Region} > /dev/null 2>.state/log.${Region}/stderr.out &
    echo -n $! > .state/${Region}.pid
done
echo ""

echo "⏳ Waiting for clusters to stabilize"
while [ -x "$globalUp" ] || [ -z "$dc1Up" ]
do
  if [ -z "$globalMsg" ]; then
    # First pass through the loop 
    globalMsg="  - checking global: "
    dc1Msg="  - checking    dc1: "
  else 
    # move back up 2 lines 
    tput el1; tput cuu1; tput cuu1; tput ed
  fi
  sleep 1

  if [ "$globalUp" == "" ]; then
    curl -q -s -f http://127.0.0.1:14646/v1/agent/health > /dev/null
    if [ $? -eq 0 ]
    then
      globalMsg="${globalMsg}✅"
      globalUp=true
    else
      globalMsg="${globalMsg}."
    fi
  fi
  if [ "$dc1Up" == "" ]; then
    curl -q -s -f http://127.0.0.1:24646/v1/agent/health > /dev/null
    if [ $? -eq 0 ]
    then
      dc1Msg="${dc1Msg}✅"
      dc1Up=true
    else
      dc1Msg="${dc1Msg}."
    fi
  fi
  echo "${globalMsg}"
  echo "${dc1Msg}"
done
echo ""
echo "🔗 Joining clusters"
export NOMAD_ADDR=http://127.0.0.1:14646
nomad server join 127.0.0.1:24648
echo ""

echo "🎉 The environment is running."
echo "To connect to \"global\" region, run:"
echo "  export NOMAD_ADDR=http://127.0.0.1:14646"
echo "To connect to \"dc1\" region, run:"
echo "  export NOMAD_ADDR=http://127.0.0.1:24646"
