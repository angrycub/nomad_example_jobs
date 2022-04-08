#!/bin/bash

printError () {
  echo -n "- Checking ${CUR_FILE} ... "

  icon="🔴"
  if [ ${NO_ICON:-unset} != "unset" ]; then
    icon="[ERROR]"
  fi
  echo ${icon}
  if [ "${DEBUG:-unset}" != "unset" ]; then
    echo "Command output:"
    echo ""
    echo "${1}" | awk '/^$/{next} {print $0}'
    echo ""
  fi
  output "${CUR_FILE}"  "${icon}"  "$(echo "${1}" | awk '/^$/{next} {print $0}')"

  continue
}

printWarning () {
  echo -n "- Checking ${CUR_FILE} ... "

  icon="🟡"
  if [ ${NO_ICON:-unset} != "unset" ]; then
    icon="[WARN]"
  fi
  echo ${icon}
  if [ "${DEBUG:-unset}" != "unset" ]; then
    echo "Job Warning output:"
    echo ""
    echo "${1}" | awk '/Job Warnings:/{flag=1} /Job Modify Index:/{flag=0} /^$/{next} flag'
    echo ""
  fi
  output "${CUR_FILE}"  "${icon}"  "$(echo "${1}" | awk '/Job Warnings:/{flag=1} /Job Modify Index:/{flag=0} /^$/{next} flag')"

  continue
}

printSuccess () {
  if [ ${NO_SUCCESS:-unset} != "unset" ]; then
    continue
  fi

  echo -n "- Checking ${CUR_FILE} ... "

  icon="✅"
  if [ ${NO_ICON:-unset} != "unset" ]; then
    icon="[SUCCESS]"
  fi
  echo ${icon}
  output "${CUR_FILE}"  "${icon}"  ""

  continue
}

output() {
    file="${1}"
    status="${2}"
    output="${3}"

    asHTML "${file}"  "${status}"  "${output}"
}

setupOutput() {
    startHTML
}

finishOutput() {
    endHTML
}

startHTML() {
    cat <<HERE > output.html
<html><head><title>Nomad Job Tester Output</title>
<style>
body {
  font-family: Helvetica, sans-serif;
}
.out {
    white-space: pre-wrap;
}
</style>
</head>
<body>
<table border="1" width="100%">
<tr><th></th><th>Filename</th><th>Output</th></tr>
HERE
}

asHTML() {
    file="${1}"
    status="${2}"
    output="${3}"
    maybeOut=""
    if [ "${output}" != "" ]; then
      maybeOut="<details><summary>Show Output</summary><pre class=out><code>${output}</code></pre></details>"
    fi
    echo "<tr><td style=\"width: 2em;\" align=\"center\">${status}</td><td width=\"25%\">${file}</td><td>${maybeOut}</td></tr>" >> output.html
}

endHTML() {
    cat <<HERE >> output.html
</table>
</body></html>
HERE
}



## Main begins here 

setupOutput

files=$(find -s ${1:-.}  -name "*.nomad")
for file in ${files}; do

  CUR_FILE=${file}
  out=$(nomad plan ${CUR_FILE} 2>&1)
  ec=$? 

  if [ "${ec}" == "255" ]; then
    printError "${out}"
  fi

  if [ "${ec}" == "1" ]; then
    dep=$(echo "${out}" | grep -c "Job Warnings:")

    if [ "$dep" != 0 ]; then
      printWarning "${out}"
    fi
  fi
  printSuccess
done

finishOutput
