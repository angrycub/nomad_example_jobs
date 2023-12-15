# CircuitPython Serial Reader

This example demonstrates mounting a character device into a Docker container
with Nomad. This example uses an Adafruit PropMaker Feather running a small
CircuitPython program that generates printed output to the serial interface.

When connecting the Feather to my Ubuntu Linux 22.04 machine, it creates the
`/dev/ttyACM0` device. You can verify that everything is working properly by
connecting to the machine that you've plugged your Feather into and running
`screen /dev/ttyACM0 115200`. If things are working as expected, you should
see output similar to the following.

```
red 1
red 2
red 3
...
blue 1
blue 2
...
```

Exit the **screen** command by pressing `Ctrl-A` and then `\`. Some versions
of **screen** use `Ctrl-A` then `Ctrl-\`, so try that if the first one does
not work as expected.

The Nomad job exposes the `/dev/ttyACM0` device inside of the Alpine
container as `/dev/propmaker`. Upon starting, it installs **screen** via
**apk**. Finally, it starts **screen** with the same command as you used
while testing the connection earlier, updating the path to `/dev/propmaker`.

Start it by running `nomad job run circuitpy_reader.nomad`

The job will not be able to place immediately, because it requires an instance
of dynamic node metadata to indicate the node that the hardware is attached to.

You can use either the Nomad CLI, Nomad UI, or Nomad API to provide this value.

<details><summary>Nomad CLI Instructions</summary>

For a single node `-dev` cluster, run 

```
nomad node meta drivers.propmaker=/dev/ttyACM0
```

For a cluster with multiple clients, first obtain the Client ID of the Nomad
client hosting the PropMaker Feather. Run `nomad node status` to get a list
of clients and their IDs.

```
nomad node status
```

```
ID        Node Pool  DC   Name                 Class   Drain  Eligibility  Status
5a934da0  default    dc1  nomad-client-iron02  <none>  false  eligible     ready
8f211b6b  default    dc1  nomad-client-iron03  <none>  false  eligible     ready
f9e01832  default    dc1  nomad-client-iron01  <none>  false  eligible     ready
```

In my cluster, I attached the Feather to **nomad-client-iron02**, so I will be
using `5a934da0` as the value for the `-node-id` flag on the `nomad node meta`
command.

```
nomad node meta -node-id 5a934da0 drivers.propmaker=/dev/ttyACM0
```

<details>

Once you have applied the dynamic node metadata, there will be a small wait while
the metadata is replicated back to the Nomad Servers. Once present, the servers
will unblock the job and schedule it on the target client node.

You can use the `nomad job status` command to check on the scheduling and start-
up progress of the task.

```
nomad job status circuitpy-reader
```

Once running, you should be able to run `nomad alloc logs` command to see the
PropMaker Feather's serial output.

## Cleaning up

### Stop the job

### Remove the dynamic node metadata

```
nomad node meta -node-id 5a934da0 -unset drivers.propmaker
```


