# Provide HCL2 variable values using environment variables

This example contains two jobs that consumes multiple HCL2 variable files and
populates the Nomad job with them during submission from the CLI.

The `shared.vars` file defines two variables:

- `datacenters = [ "dc1" ]`
- `docker_image = "redis"`

The job .vars files set the `image_version_«job name»` value to complete the
job specification.

## Run the examples

```bash
nomad job run -var-file=./shared.vars -var-file=./job1.vars job1.nomad
```

Nomad will start a Redis 3 container

```bash
nomad job run -var-file=./shared.vars -var-file=./job2.vars job2.nomad
```

Nomad will start a Redis 4 container

```bash
nomad job run -var-file=./shared.vars -var-file=./job3.vars job3.nomad
```

Nomad will start a hello-world:latest container by overriding `docker_image` from
the `./shared.vars` file.

## Stop the examples

```bash
nomad job stop job1
nomad job stop job2
nomad job stop job3
```
