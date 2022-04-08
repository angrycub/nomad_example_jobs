### Dynamic job configuration

The `interpolated_job.nomad` sample uses a job-specific secure variable to determine what version of Redis it should start.

Run the `makeJobVars.sh` script to create the required variables.

```shell
./makeJobVars.sh
```

Run the `interpolated_job.hcl` file to start the Redis job

```shell
nomad job run interpolated_job.nomad
```

Run the following one-liner to get the created allocation ID into an environment
variable.

```shell
export REDIS_ALLOC_ID=$(nomad alloc status -t '{{ range .}}{{if and (eq .JobID "example") (eq .DesiredStatus "run")}}{{.ID}}{{end}}{{end}}')
```

Use the `nomad alloc exec` command to run the `redis-server -v` command inside
of the job's running Docker container.

```shell
$ nomad alloc exec ${REDIS_ALLOC_ID} redis-server -v
Redis server v=4.0.14 sha=00000000:0 malloc=jemalloc-4.0.3 bits=64 build=7c61ee3c1f3ffc88
```

Update the variable by using the `nomad var get` command and piping its output to
the `nomad var put` command.

```shell
$ nomad var get --format=json nomad/jobs/example | nomad var put - version=4
Reading whole JSON variable specification from stdin
Successfully created secure variable "nomad/jobs/example"!
```

Rerun the `nomad alloc exec` command to verify that the Redis version has been
updated.

> **NOTE:** While the container is restarting, you might get the following error.
>
> ```text
> failed to exec into task: task "redis" is not running.
> ```
>
> If you do, try running the command again in a few seconds.

```shell
$ nomad alloc exec 64c66418-7b01-db43-02f9-eb169ce99921 redis-server -v
Redis server v=7.0.4 sha=00000000:0 malloc=jemalloc-5.2.1 bits=64 build=eed36d5f4a2dd39c
```
