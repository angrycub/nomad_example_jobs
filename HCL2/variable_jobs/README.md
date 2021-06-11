# Using HCL2 to add variables to Nomad jobs

Nomad's HCL2 support enables you to use variables in your Nomad job specifications.
This can decrease the number of job files you have to maintain in source control
and can encourage job reuse.

This example contains a job that consumes HCL2 variables and uses them to generate
a Docker service job.

The `job.nomad` file defines 3 variables:

- `datacenters`(default `[ "dc1" ]`) — a list of the Nomad datacenters to run
  the job in.

- `docker_image` — The docker image name to run. Since this is a service job,
  the image needs to run until explicitly stopped. The `redis` container is a
  small example that works well.

- `image-version` — The specific version of the `docker_image` image to run. For
  the `redis` container, try versions like "3", "4", and "latest"

## Quickstart

### Run the example

```bash
nomad job run -var docker_image="redis" -var image_version="3" job.nomad
```

Nomad will start a `redis:3` container

```bash
nomad job run -var docker_image="redis" -var image_version="latest" job.nomad
```

Nomad will stop the `redis:3` container and start a `redis:latest` container.

## Stop the examples

```bash
nomad job stop job
```

## Submitting variable values

There are three ways to provide values for HCL2 variables.

- Individual `-var` flags
- With a variable file and the `-var-file` flag
- Environment variables

You can use one or more of these methods in the same call.

### Precedence (highest to lowest)

- `-var` flag (if a variable repeats, the last one in the command line wins)
- `-var-file` flag (if a variable repeats in the files, the last one listed in the command line wins)
- environment variables

### Naming environment variables

To provide a value to the HCL2 engine via the environment, you need to create
an environment variable named `NOMAD_VAR_«variable name»`. For example, to
set the value of the `docker_image` variable, create an environment variable
named `NOMAD_VAR_docker_image`.

## Using variable files with more than one job

The HCL2 engine expects every variable that you supply using the `-var` or
`-var-file` flags to be consumed by the job specification.

Following are some techniques to work around this constraint:

- [Provide HCL2 variable values using environment variables](./env-vars)
- [Use more than one `-var-file` flag](./var-files)
- [Decode the contents of an external file into a `local` variable](./decode-external-file)
