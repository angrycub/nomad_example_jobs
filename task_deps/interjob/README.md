# Modeling Inter-Service Dependencies using Nomad Task Dependencies

Nomad task dependencies provide the ability to use init-style tasks. These tasks can be used to delay a jobs main tasks from running until a service that the job depends on is available.  

## Create the job files
This example uses simple looping scripts to mock service payloads. Create a file named `myservice.nomad` with the following content.

```hcl
job "myservice" {
  datacenters = ["dc1"]
  type        = "service"

  group "myservice" {
    task "myservice" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The service is running! && while true; do sleep 2; done"]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      service {
        name = "myservice"
      }
    }
  }
}

```

Create a file named `myapp.nomad` with the collowing content.

```hcl
job "myapp" {
  datacenters = ["dc1"]
  type        = "service"

  group "myapp" {
    # disable deployments
    update {
      max_parallel = 0
    }

    task "await-myservice" {
      driver = "docker"

      config {
        image       = "busybox:1.28"
        command     = "sh"
        args        = ["-c", "echo -n 'Waiting for service'; until nslookup myservice.service.consul 2>&1 >/dev/null; do echo '.'; sleep 2; done"]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }
    }

    task "myapp-container" {
      driver = "docker"

      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "echo The app is running! && sleep 3600"]
      }

      resources {
        cpu    = 200
        memory = 128
      }
    }
  }
}

```

This job contains a prestart task that will query a Consul DNS API endpoint for the "myservice" service.  

Note, you might need to add the `dns_servers` value to the config stanza of the await-myservice task in the myapp.nomad file to direct the query to a DNS server that can receive queries on port 53 for your Consul DNS query root domain.


## Run the myapp job

Run `nomad run myapp.nomad`.  

```shell
$ nomad run myapp.nomad
```

The job will launch and provide you an allocation ID in the output.

```plaintext
$ nomad run myapp.nomad
==> Monitoring evaluation "01c73d5a"
    Evaluation triggered by job "myapp"
    Allocation "3044dda0" created: node "f26809e6", group "myapp"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "01c73d5a" finished with status "complete"
```

Run the `nomad alloc status` command with the provided allocation ID.

```shell
$ nomad alloc status 3044dda0
```

## Verify myapp-container is blocked

You will receive a lot of information back. For this guide, focus on the status of each task. Each task's status is output in lines that look like `Task "await-myservice" is "running"`.

```plaintext
$ nomad alloc status 3044dda0
ID                  = 3044dda0-8dc1-1bac-86ea-66a3557c67d3
Eval ID             = 01c73d5a
Name                = myapp.myapp[0]
Node ID             = f26809e6
Node Name           = nomad-client-2.node.consul
Job ID              = myapp
Job Version         = 0
Client Status       = running
Client Description  = Tasks are running
Desired Status      = run
Desired Description = <none>
Created             = 43s ago
Modified            = 42s ago

Task "await-myservice" is "running"
Task Resources
CPU        Memory          Disk     Addresses
3/200 MHz  80 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:07:26Z
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:07:26-04:00  Started     Task started by client
2020-03-18T13:07:26-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client

Task "myapp-container" is "pending"
Task Resources
CPU      Memory   Disk     Addresses
200 MHz  128 MiB  300 MiB  

Task Events:
Started At     = N/A
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type      Description
2020-03-18T13:07:26-04:00  Received  Task received by client
```

Notice that the await-myservice task is running and that the myapp-container task is pending. The myapp-container will remain in pending until the await-myservice container completes successfully.

## Start myservice job

You can run the myservice.nomad job to create a job that creates a "myservice" service in Consul. This will allow the await-myservice task to terminate successfully. Run `nomad run myservice.nomad`.

```shell
$ nomad run myservice.nomad
```

Nomad will start the job and return information about the scheduling information.

```plaintext
$ nomad run myservice.nomad
==> Monitoring evaluation "f31f8eb1"
    Evaluation triggered by job "myservice"
    Allocation "d7767adf" created: node "f26809e6", group "myservice"
    Evaluation within deployment: "3d86e09a"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "f31f8eb1" finished with status "complete"
```

Re-check the allocation status of your myapp allocation.

```shell
$ nomad alloc status 3044dda0
```

## Verify myapp-container is running

Finally, check the output of the alloc status command for the task statuses.

```plaintext
$ nomad alloc status 3044dda0
ID                  = 3044dda0-8dc1-1bac-86ea-66a3557c67d3
Eval ID             = 01c73d5a
Name                = myapp.myapp[0]
Node ID             = f26809e6
Node Name           = nomad-client-2.node.consul
Job ID              = myapp
Job Version         = 0
Client Status       = running
Client Description  = Tasks are running
Desired Status      = run
Desired Description = <none>
Created             = 21m38s ago
Modified            = 7m27s ago

Task "await-myservice" is "dead"
Task Resources
CPU        Memory          Disk     Addresses
0/200 MHz  80 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:07:26Z
Finished At    = 2020-03-18T17:21:35Z
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:21:35-04:00  Terminated  Exit Code: 0
2020-03-18T13:07:26-04:00  Started     Task started by client
2020-03-18T13:07:26-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client

Task "myapp-container" is "running"
Task Resources
CPU        Memory          Disk     Addresses
0/200 MHz  32 KiB/128 MiB  300 MiB  

Task Events:
Started At     = 2020-03-18T17:21:37Z
Finished At    = N/A
Total Restarts = 0
Last Restart   = N/A

Recent Events:
Time                       Type        Description
2020-03-18T13:21:37-04:00  Started     Task started by client
2020-03-18T13:21:35-04:00  Driver      Downloading image
2020-03-18T13:21:35-04:00  Task Setup  Building Task Directory
2020-03-18T13:07:26-04:00  Received    Task received by client
```

Notice, the await-myservice task is dead and based on the Recent Events table terminated with "Exit Code: 0"—this indicates that it completed successfully. The myapp-container has now moved to the "running" status and the container is running.

