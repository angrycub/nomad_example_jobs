# Setting a Docker container's hostname to the Nomad Client name

## Requirements

This scenario is more interesting when run in a Nomad cluster with multiple
clients, but it will work in a cluster as small as a dev agent.

## Steps

You can either run the provided `finished.nomad` job specification or follow
the next few steps to create the job specification yourself. If you choose to
use the finished.nomad job specification, skip to the [Run the job][#RunTheJob]
step

### Build the job specification

Run `nomad job init -short` to produce the example Redis docker job.

```shell
$ nomad job init -short
Example job file written to example.nomad
```

Open up the `example.nomad` job file in a text editor.
Inside the `job "example" > group "cache" > task "redis" > config` block, add
the following:

```hcl
        hostname       = "${attr.unique.hostname}"
```

Set the count on the `group "cache"` to 3.

```hcl
  group "cache" {
    count = 3
    ...
```

### Run the job <a name="RunTheJob"></a>

Run the job in your Nomad cluster and wait for the instances to become healthy.
You will be returned to a shell prompt.

```shell
nomad job run example.nomad
```

### Validate the allocations' hostnames
Once you have been returned to a shell prompt, running `view.sh` shows output
like the following. The Allocation IDs, Node Names, and Host Names will vary
from the output here, but you should be able to note that the Docker host name
matches the Nomad Client's Node Name.

```shell
$ ./view.sh
Allocation ID                         Node Name (Nomad)           Host Name (Docker)
0053d552-f461-519e-2b26-13f5e8b67524  nomad-client-3.node.consul  nomad-client-3.node.consul
5767a2a6-38a4-2330-d692-9badc5840edb  nomad-client-1.node.consul  nomad-client-1.node.consul
59dc75cd-5acf-e21d-7d5f-befed3dfa336  nomad-client-1.node.consul  nomad-client-1.node.consul
```
