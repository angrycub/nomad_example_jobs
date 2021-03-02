## get_fact_from_consul

These demonstration jobs use Consul templates to fetch values for substitution in
Docker jobs. These values can be used as interpolated values at workload runtime
and are seen as concrete values in `docker inspect`. However, they are also
available to the workload itself.

- **image.nomad** - uses an enviroment variable that is made concrete during
  container startup. However, they are available to the workload as well.

- **args.nomad** - uses the `template` stanza to build environment variables
  and provides them to the job via the `args` list. These are handled by the
  starting workload.


## image.nomad

requires a consul key named `test/redis/docker-tag`

```shell-session
$ consul kv put test/redis/docker-tag "4.0"
```

- Run the job. Find the client node that it's running on. SSH there.
- Run `docker ps` to find the workload; note that it's running the version from the label.


## args.nomad

requires a consul key named `test/echo/content`

```shell-session
$ consul kv put test/echo/content "hello world!"
```

- Run the job. Find the client node that it's running on. SSH there.
- Run `docker ps` to find the workload
- Run `docker inspect` on the running container.
- Look for `"Cmd"` and note that the environment variables have been expanded
to their concrete values.

