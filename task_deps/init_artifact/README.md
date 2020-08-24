# init-artifact.nomad

This sample job demonstrates priming the alloc directory with artifacts and
templates generated with an init job.  The `template` task then runs the
downloaded levant executable and renders the template that the init task
placed in the alloc folder.

- **batch-init-artifact.nomad** - batch version of the job

- **service-init-artifact.nomad** - service version (renders and then goes
  into a sleep loop)

