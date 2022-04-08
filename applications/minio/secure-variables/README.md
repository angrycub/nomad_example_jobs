# Minio S3-compatible Storage

This job uses Nomad Host Volumes to provide an internal s3 compatible storage
environment which can be used to host private artifacts for a Nomad clusters.

## Prerequisites

- **Nomad 1.4** - This job leverages Nomad service registrations for locating the
  MinIO instance and used Nomad Variables.

## Necessary configuration

### Create the host volume in the configuration

Create a folder on one of your Nomad clients to host your registry files. This
example uses `/opt/volumes/minio-data`

```shell-session
$ mkdir -p /opt/volumes/minio-data
```

Add the host_volume information to the client stanza in the Nomad configuration.

```hcl
client {
# ...
  host_volume "minio-data" {
    path = "/opt/volumes/minio-data"
    read_only = false
  }
}
```

Restart Nomad to read the new configuration.

```shell-session
$ systemctl restart nomad
```
