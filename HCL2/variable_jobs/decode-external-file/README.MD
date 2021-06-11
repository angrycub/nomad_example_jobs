# Decode the contents of an external file into a `local` variable

The HCL2 `file` function when paired with the `jsondecode` or `yamldecode`
function enables you to externalize shared configuration elements for Nomad jobs
to a JSON or YAML file.

This example contains two jobs that read the `env.json` file to and use values
from it to configure the Nomad job during submission from the CLI.

## Run the examples

```bash
nomad job run -var="config=env.json" job1.nomad
```

Nomad will start a Redis 3 container

```bash
nomad job run -var="config=env.json" job2.nomad
```

Nomad will start a Redis 4 container

## Stop the examples

```bash
nomad job stop job1
nomad job stop job2
```
