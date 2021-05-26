# WordPress

This job demonstrates several useful patterns for creating Nomad jobs:

- Nomad Host Volumes for persistent storage
- Using a pre-start task to wait until a dependency is available
- Template driven configuration to reduce static port references

## Prerequisites

- **Consul** — This job leverages Consul service registrations to locate
  the supporting MySQL instance.

## Necessary configuration

### Create the host volume in the configuration

Create a folder on one of your Nomad clients to host your registry files. This
example uses `/opt/nomad/volumes/wordpress-db`.

```shell-session
mkdir -p /opt/nomad/volumes/wordpress-db
```

Add the `host_volume` information to the client stanza in the Nomad configuration.
If your `-config` flag points to a directory, you can create this as a standalone
file in that same folder.

```hcl
client {
# ...
  host_volume "my-website-db" {
    path = "/opt/nomad/volumes/my-website-db"
    read_only = false
  }
}
```

Restart Nomad to read the new configuration.

```shell
systemctl restart nomad
```
