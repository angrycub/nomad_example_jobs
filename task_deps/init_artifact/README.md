# init-artifact.nomad

This sample job demonstrates priming the alloc directory with artifacts and
templates generated with an init job.  The main workload then runs the
downloaded levant executable and renders the template that the init task
placed in the alloc folder.

