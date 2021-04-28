# Docker Registry

This job uses Nomad Host Volumes to provide an internal Docker registry which
can be used to host private containers for a Nomad cluster.

## Prerequisites

- **Consul** - This job leverages Consul service registrations for locating the registry
instances.

## Necessary configuration

### Create the host volume in the configuration

Create a folder on one of your Nomad clients to host your registry files. This
example uses `/opt/volumes/docker-registry`

```shell-session
$ mkdir -p /opt/volumes/docker-registry
```

Add the host_volume information to the client stanza in the Nomad configuration.

```hcl
client {
# ...
  host_volume "docker-registry" {
    path = "/opt/volumes/docker-registry"
    read_only = false
  }
}
```

Restart Nomad to read the new configuration.

```shell-session
$ systemctl restart nomad
```

### Add your registry to your daemon.json file

If you would like to use your registry with Nomad and do not want to configure
SSL, you can add the following to the `daemon.json` file on each of your Nomad
clients and restart Docker.

```json
{
  "insecure-registries" : ["registry.service.consul:5000"],
}
```

You will need to do this on any machine that you would like to push to or pull
from your registry.

