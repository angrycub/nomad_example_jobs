# Wordpress

This job demonstrates several useful patterns for creating Nomad jobs:

- Nomad Host Volumes for persistent storage
- Using a prestart task to wait until a dependency is available
- Template driven configuration to minimize static port references

## Prerequisites

- **Consul** - This job leverages Consul service registrations to locate the
  supporting MySQL instance.

## Necessary configuration

### Create the host volume in the configuration

Create a folder on one of your Nomad clients to host your registry files. This
example uses `/opt/volumes/my-website-db`

```shell-session
$ mkdir -p /opt/volumes/my-website-db
```

Add the host_volume information to the client stanza in the Nomad configuration.

```hcl
client {
# ...
  host_volume "my-website-db" {
    path = "/opt/volumes/my-website-db"
    read_only = false
  }
}
```

Restart Nomad to read the new configuration.

```shell-session
$ systemctl restart nomad
```


