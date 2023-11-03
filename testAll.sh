files=$(find -s ${1:-.}  -name "*.nomad")
for file in ${files}; do
  export QUIET_SUCCESS=true
  ./test.sh $file
done
