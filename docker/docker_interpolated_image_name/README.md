# Using interpolated Docker image versions

Prerequisites:

- Nomad
  - Docker
- Consul

Rough Notes:

- The docker image path is interpolated
- The Nomad `template` block can be used to create environment variables and has access to Consul values
- You can use the `keyOrDefault` template function to fetch a value from Consul KV
- You can set and update the value using the `consul kv put` command.
- Depending on template `change_mode`, this might restart the job.
- Image caching is at play, so immutable tags help this scenario

```shell-session
consul kv put service/redis/version 3.2
```
