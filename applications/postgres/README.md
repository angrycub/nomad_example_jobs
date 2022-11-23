# Stateful example of Postgres with Host Volumes

## Configure a supportive host volume

This job uses a volume named
`pg-data`. On one of your Nomad clients, either create an additional
configuration file (if you're `config` is pointed to a directory)
or add a `host_volume` stanza to your existing client configuration
similar to the following.

```hcl
client {
  host_volume "pg-data" {
    path = "/opt/nomad/volumes/pg-data"
    read_only = false
  }
}
```

Create the directory to support the volume.

```shell-session
$ mkdir -p /opt/nomad/volumes/pg-data
```

Restart Nomad to enable the new host volume.

```shell-session
$ systemctl restart nomad
```

Verify that the host volume is available.

```shell-session
$ nomad node status -self -verbose
```

Once the client finishes starting, you should see the `pg-data` host volume
listed in the **Host Volumes** section of the output.

```
Host Volumes
Name           ReadOnly  Source
pg-data        false     /opt/nomad/volumes/pg-data
```

Run the job.

```shell-session
$ nomad job run postgres.nomad
```

Once the job starts, check the allocation status to determine what IP and
port you need to connect to.

Connect to the instance using a postgres client at the scheduled IP address
and port. Use user `postgres` and secret `mysecretpassword`.
