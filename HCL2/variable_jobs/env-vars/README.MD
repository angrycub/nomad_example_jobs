# Provide HCL2 variable values using environment variables

This example contains two jobs that read HCL2 variable values from the
environment and populates the Nomad job with them during submission from the
CLI. This can be a very powerful feature when paired with [`direnv`],
[`envconsul`], and other tools that can manipulate environment variables.

## Run the sample

### Read in the environment variables

```bash
source ./env.vars
```

```bash
nomad job run job1.nomad
```

Nomad will start a Redis 3 container

```bash
nomad job run job2.nomad
```

Nomad will start a Redis 4 container

## Stop the example

```bash
nomad job stop job1
nomad job stop job2
unset NOMAD_VAR_datacenters \
  NOMAD_VAR_docker_image_job1 \
  NOMAD_VAR_docker_image_job2
```

[`envconsul`]: https://github.com/hashicorp/envconsul
[`direnv`]: https://direnv.net/
