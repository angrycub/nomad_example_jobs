## Use Consul for KV Path

This sample will use a Consul KV key to determine a path for other Consul KV
elements using `printf` to compose it.


## Set up

Build a small set of Consul KV keys for the job to use

```
consul kv put template/current "config1"
consul kv put template/config1/name "config1.service.consul"
consul kv put template/config1/ip "10.0.1.100"
consul kv put template/config1/port "7777"
consul kv put template/config2/name "config2.service.consul"
consul kv put template/config2/ip "10.0.2.200"
consul kv put template/config2/port "8888"
```

Run the `template.nomad` job

```
nomad job run template.nomad
```

You will receive scheduling information in the output; note the allocation ID.

```
==> Monitoring evaluation "ba76383e"
    Evaluation triggered by job "template"
==> Monitoring evaluation "ba76383e"
    Allocation "e4d4bcf1" created: node "f7bc1f2d", group "group"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "ba76383e" finished with status "complete"
```

Fetch the output template file using the `nomad alloc fs` command.

```
nomad alloc fs e4d4bcf1 command/local/template.out
```

Observe that the template is built with the `config1` paths.

```
Name: config1.service.consul
IP: 10.0.1.100:7777
```

Update the KV value to `config2`.

```
consul kv put template/current "config2"
```

Consul should indcate success.

```
Success! Data written to: template/current
```

Check the status of the allocation. 

```
nomad alloc status e4d4bcf1
```

Observe that your change caused Nomad to restart it.

```
ID                  = e4d4bcf1-f300-b7e7-2f8a-c252eae04822
Eval ID             = ba76383e
Name                = template.group[0]
Node ID             = f7bc1f2d
Node Name           = nomad-client-1.node.consul
Job ID              = template
Job Version         = 0
Client Status       = running
Client Description  = Tasks are running
Desired Status      = run
Desired Description = <none>
Created             = 1m23s ago
Modified            = 39s ago

Task "command" is "running"
Task Resources
CPU        Memory           Disk     Addresses
0/100 MHz  112 KiB/300 MiB  300 MiB  

Task Events:
Started At     = 2021-06-07T17:32:22Z
Finished At    = N/A
Total Restarts = 1
Last Restart   = 2021-06-07T13:32:22-04:00

Recent Events:
Time                       Type              Description
2021-06-07T13:32:22-04:00  Started           Task started by client
2021-06-07T13:32:22-04:00  Driver            Downloading image
2021-06-07T13:32:22-04:00  Restarting        Task restarting in 0s
2021-06-07T13:32:22-04:00  Terminated        Exit Code: 137, Exit Message: "Docker container exited with non-zero exit code: 137"
2021-06-07T13:32:16-04:00  Restart Signaled  Template with change_mode restart re-rendered
2021-06-07T13:31:40-04:00  Started           Task started by client
2021-06-07T13:31:39-04:00  Driver            Downloading image
2021-06-07T13:31:39-04:00  Task Setup        Building Task Directory
2021-06-07T13:31:39-04:00  Received          Task received by client
```

Now, refetch the rendered file with `nomad alloc fs`.
```
nomad alloc fs e4d4bcf1 command/local/template.out
```

Observe that the content now shows the values for the config2 paths.

```
Name: config2.service.consul
IP: 10.0.2.200:8888
```

## Clean up

Remove the running sample job.

```
nomad job stop -purge template
```

Remove the Consul keys.

```
consul kv delete template/current
consul kv delete template/config1/name
consul kv delete template/config1/ip
consul kv delete template/config1/port
consul kv delete template/config2/name
consul kv delete template/config2/ip
consul kv delete template/config2/port
```
