## Using Interpolated Docker Image Versions

Rough Notes:

- The docker image path is interpolated
- The Nomad `template` block can be used to create environment variables and has access to Consul values
- We can use the `keyOrDefault` remplate function to fetch a value from Consul KV
- We can set and update the value using the `consul kv put` command.
- Depending on template change_mode, this might restart the job.
- Image caching is at play, so immutable tags help this scenario
 
