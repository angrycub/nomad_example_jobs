#!/bin/sh
# The entrypoint is used to set some values that the
# command will use
export VAR1="foo"
export VAR2="bar"

eval $@