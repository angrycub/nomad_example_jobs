#!/bin/bash

error=0
warn=0
okay=0

printError () {
  ((error++))
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
  ((warn++))
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
  ((okay++))
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
    echo ""
    echo "Summary ---"
    echo "  Error: ${error}"
    echo "   Warn: ${warn}"
    echo "   Okay: ${okay}"
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
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.js"></script>
</head>
<body>
<table border="1" width="100%" id="results">
<thead><tr><th></th><th>Filename</th><th>Output</th></tr></thead>
<tbody>
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
</tbody>
</table>

<table>
<thead><tr><th>Status</th><th>Count</th></tr></thead>
<tbody>
<tr><td>Error</td><td>${error}</td></tr>
<tr><td>Warn</td><td>${warn}</td></tr>
<tr><td>Okay</td><td>${okay}</td></tr>
</tbody>
</table>

<script>
\$(document).ready( function () {
    \$('#results').DataTable({
      paging: false
    });
} );
</script>
HERE
}



## Main begins here

setupOutput

files=$(find -s ${1:-.}  -name "*.nomad")
for file in ${files}; do

  CUR_FILE=${file}
  pushd `dirname ${file}` > /dev/null
  out=$(nomad plan `basename ${CUR_FILE}` 2>&1)
  ec=$?
  popd > /dev/null
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
