# Handoff

This job file demonstrates using an init job to write a rendered template into a location that
can be picked up by another job.  It also demonstrates the use of the $NOMAD_ALLOC_DIR variable
with a raw_exec job (since they have access to the entire host's filesystem)

