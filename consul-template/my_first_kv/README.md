[template]:https://www.nomadproject.io/docs/job-specification/template.html#environment-variables
## My First KV

This job will fetch a single value from Consul and pass it as an environment
variable into the Redis Docker container from the sample job.  The job file
itself is a cut down of the output from `nomad init --short` to take out
unnecessary whitespace.

One important note, in order to use the consul-template library for creating
dynamic environment variables, you must use the [template] stanza with 
`env = true`.  This allows you to create the key/value environment variable as a
file and then read it into the environment.  The Nomad `secrets` directory is
commonly used as a destination for these rendered files.

You can create the necessary Consul KV value with the following command:

```
$ consul kv put my-first-kv/testData MyAwesomeValue
Success! Data written to: my-first-kv/testData
```

When you are done, or to experiment with a missing value, delete the key with:

```
$ consul kv delete my-first-kv/testData
Success! Deleted key: my-first-kv/testData
```
