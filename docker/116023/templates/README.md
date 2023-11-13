# Using Nomad variables as a template source

Sometimes, you would prefer to have the templates stored externally
to the job specification; and Nomad variables seems like it would
do the trick. However, the library that powers the `template`
block doesn't perform a rendering pass after the variables have been loaded
into the template context.

## Requirements

- Nomad 1.4.0+ for variable support
- The following variable stored in your target cluster:

  ```bash
  nomad var put -force nomad/jobs/example/g1/template_sidecar template=@config.tpl
  ```

## Variations

- **naive** - demonstrates the issue by attempting to render a template fetched
  from a variable.

- **sidecar** - demonstrates a workaround that fetches the template data using
  an init sidecar and then rendering that template source in the actual task.
