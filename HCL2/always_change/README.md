# Use HCL2 to make re-runnable batch jobs

Nomad will refuse to run a batch job again unless it detects a change to the job.
This behavior exists to prevent duplicate job submissions from creating unnecessary
work—unchanged jobs are "the same job" to Nomad. A Nomad job's `meta` stanza is
an ideal place to make changes to a Nomad job that do not change the behavior of
the job itself. Some ways to provide variation in a meta value are using an HCL2
variable or the `uuidv4()` function.

- [`before.nomad`] — Demonstrates the normal behavior.

- [`uuid.nomad`] — Use a random UUID to change the job every time it is run. This
  guarantees that Nomad will always run the submitted job.

- [`variable.nomad`] — Submit a variable at runtime. This can preserve the single
  run behavior in cases where the job submission is a duplicate.

## Nomad's default behavior

Run the `before.nomad` job. Nomad will start a copy of the 
`hello-world:latest` docker container. This container outputs some text and exits.

```
$ nomad run before.nomad
==> Monitoring evaluation "1fef4d80"
    Evaluation triggered by job "before.nomad"
==> Monitoring evaluation "1fef4d80"
    Allocation "7e6a767b" created: node "14ab9290", group "before"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "1fef4d80" finished with status "complete"
```

Check the status of the allocation created by the run command.

```
$ nomad alloc status 7eg   
ID                  = 7e6a767b-5604-5268-653b-905948928de5
Eval ID             = 1fef4d80
Name                = before.nomad.before[0]
Node ID             = 14ab9290
Node Name           = nomad-client-2.node.consul
Job ID              = before.nomad
Job Version         = 0
Client Status       = complete
Client Description  = All tasks have completed
Desired Status      = run
Desired Description = <none>
Created             = 6m55s ago
Modified            = 6m45s ago

Task "hello-world" is "dead"
Task Resources
CPU      Memory   Disk     Addresses
100 MHz  300 MiB  300 MiB  

Task Events:
Started At     = 2021-05-18T18:03:10Z
Finished At    = 2021-05-18T18:03:10Z
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2021-05-18T14:03:10-04:00  Terminated  Exit Code: 0
2021-05-18T14:03:10-04:00  Started     Task started by client
2021-05-18T14:03:01-04:00  Driver      Downloading image
2021-05-18T14:03:01-04:00  Task Setup  Building Task Directory
2021-05-18T14:03:01-04:00  Received    Task received by client
```

As expected, the Docker container finished and exited with exit code 0.

Check the status of the job to verify that its status is `dead`.

```
$ nomad status             
ID            Type     Priority  Status   Submit Date
before.nomad  batch    50        dead     2021-05-18T14:03:00-04:00
```

Try running the `before.nomad` job again.

```
$ nomad run before.nomad
==> Monitoring evaluation "a855fa2b"
    Evaluation triggered by job "before.nomad"
==> Monitoring evaluation "a855fa2b"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "a855fa2b" finished with status "complete"
```

Note that this time, Nomad did not schedule an allocation and the
job remains dead. This is expected and is a safety feature of Nomad
to prevent duplicated submissions of the same job from creating
unnecessary duplicate work.

If your job should always run you can use one of the following
techniques to inject variation in ways that don't require you
to alter the job files contents.

## Techniques

### Use a UUID as an ever-changing value

```text
$ nomad run uuid.nomad 
==> Monitoring evaluation "27fe0c84"
    Evaluation triggered by job "uuid.nomad"
==> Monitoring evaluation "27fe0c84"
    Allocation "6de97aa7" created: node "14ab9290", group "uuid"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "27fe0c84" finished with status "complete"
```

```text
$ nomad alloc status 6de
ID                  = 6de97aa7-e6b1-c6bf-e8e0-16d5f7ed39bf
Eval ID             = 27fe0c84
Name                = uuid.nomad.uuid[0]
Node ID             = 14ab9290
Node Name           = nomad-client-2.node.consul
Job ID              = uuid.nomad
Job Version         = 0
Client Status       = complete
Client Description  = All tasks have completed
Desired Status      = run
Desired Description = <none>
Created             = 6m52s ago
Modified            = 6m50s ago

Task "hello-world" is "dead"
Task Resources
CPU      Memory   Disk     Addresses
100 MHz  300 MiB  300 MiB  

Task Events:
Started At     = 2021-05-18T18:07:33Z
Finished At    = 2021-05-18T18:07:33Z
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2021-05-18T14:07:33-04:00  Terminated  Exit Code: 0
2021-05-18T14:07:33-04:00  Started     Task started by client
2021-05-18T14:07:31-04:00  Driver      Downloading image
2021-05-18T14:07:31-04:00  Task Setup  Building Task Directory
2021-05-18T14:07:31-04:00  Received    Task received by client
```

```text
$ nomad status          
ID            Type     Priority  Status   Submit Date
uuid.nomad    batch    50        dead     2021-05-18T14:07:30-04:00
before.nomad  batch    50        dead     2021-05-18T14:03:00-04:00
```

```text
$ nomad run uuid.nomad
==> Monitoring evaluation "2943fe82"
    Evaluation triggered by job "uuid.nomad"
    Allocation "61f5861a" created: node "f7bc1f2d", group "uuid"
==> Monitoring evaluation "2943fe82"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "2943fe82" finished with status "complete"
```

### Use an HCL2 variable

Using a variable can allow you to leverage Nomad's default behavior
of not running unchanged work, but also to provide a change to the
job without requiring a round trip to source control.

```text
$ nomad run -var run_index=1 variable.nomad
==> Monitoring evaluation "454f6fb4"
    Evaluation triggered by job "variable.nomad"
==> Monitoring evaluation "454f6fb4"
    Allocation "74f9cbf5" created: node "f7bc1f2d", group "variable"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "454f6fb4" finished with status "complete"
```

```text
$ nomad alloc status 74f                    
ID                  = 74f9cbf5-a793-5022-c831-b83e31712725
Eval ID             = 454f6fb4
Name                = variable.nomad.variable[0]
Node ID             = f7bc1f2d
Node Name           = nomad-client-1.node.consul
Job ID              = variable.nomad
Job Version         = 0
Client Status       = complete
Client Description  = All tasks have completed
Desired Status      = run
Desired Description = <none>
Created             = 6m52s ago
Modified            = 6m48s ago

Task "hello-world" is "dead"
Task Resources
CPU      Memory   Disk     Addresses
100 MHz  300 MiB  300 MiB  

Task Events:
Started At     = 2021-05-18T18:21:27Z
Finished At    = 2021-05-18T18:21:27Z
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2021-05-18T14:21:27-04:00  Terminated  Exit Code: 0
2021-05-18T14:21:27-04:00  Started     Task started by client
2021-05-18T14:21:24-04:00  Driver      Downloading image
2021-05-18T14:21:24-04:00  Task Setup  Building Task Directory
2021-05-18T14:21:24-04:00  Received    Task received by client
```

```text
$ nomad status          
ID              Type   Priority  Status  Submit Date
variable.nomad  batch  50        dead    2021-05-18T14:21:23-04:00
```

Resubmit the job with the same run_index value [1].

```text
$ nomad run -var run_index=1 variable.nomad      
==> Monitoring evaluation "4d7064ea"
    Evaluation triggered by job "variable.nomad"
==> Monitoring evaluation "4d7064ea"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "4d7064ea" finished with status "complete"
```

Note that Nomad does not re-run the job. Now, change the
run_index value to `2` and run the command again.

```text
>>>>>>> 02e089a (Fix merge conflict)
$ nomad run -var run_index=2 variable.nomad
==> Monitoring evaluation "73e7902f"
    Evaluation triggered by job "variable.nomad"
==> Monitoring evaluation "73e7902f"
    Allocation "9e8cbc58" created: node "f7bc1f2d", group "variable"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "73e7902f" finished with status "complete"
```

Nomad runs a fresh allocation of the batch job.

## Clean up

Run `nomad job stop variable.nomad` to stop the job.

[`before.nomad`]: ./before.nomad
[`uuid.nomad`]: ./uuid.nomad
[`variable.nomad`]: ./variable.nomad
