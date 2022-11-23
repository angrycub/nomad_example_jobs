# Escaped Environment Variables

Suppose you have a Docker job that sets environment variables
in the entrypoint and you would like to refer to them as
arguments in the subsequent command's arguments.

This sample will use an exec job to demonstrate how this
would be accomplished in a Nomad job
