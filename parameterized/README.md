---
name: Parameterized Jobs on Nomad
products_used:
  - nomad
description: |-
  Short description about what the reader will do/learn. Limit 250 characters; include keyword for SEO.

---

# Parameterized Jobs on Nomad

Parameterized Nomad jobs encapsulate a set of work that can be carried out on various input values.

Jobs with the parameterized stanza register themselves to the cluster, but they do not run immediately.

You must "dispatch" the job with the necessary values to run them.

You dispatch a parameterized job using the `nomad job dispatch` command or the Nomad Job Dispatch API.

While dispatching the job, you can supply an opaque payload and metadata variables to customize the dispatched instance of the job.

## The `parameterized` stanza

```json
  parameterized {
    payload       = "required"
    meta_required = ["dispatcher_email"]
    meta_optional = ["pager_email"]
  }
```

## Challenge

In this tutorial, you will take a simple Nomad template job, enhance it with parameters, and dispatch it to your cluster. These basic practices can be used to create more complex batch workloads over time.

## Prerequisites

- Nomad dev agent
- Nomad cluster
  - You need either to have the `raw_exec` task driver enabled or to convert the job to use the `exec` driver.

## Build a basic batch job

Create a file named `template.nomad`. Open it in a text editor and add the following minimal job specification.

```hcl
job "«job_name»" {
  datacenters = ["«datacenter»"]

  group "«group_name»" {
    task "«job_name»" {
      driver = "«driver_type»"
    }
  }
}
```

### Populate the template placeholders

For this tutorial, replace the placeholders in the minimal job template with these values.

- **«job_name»** - `template`
- **«group_name»** - `renderer`
- **«task_name»** - `output`
- **«driver_name»** - `raw_exec`

### Set `datacenters`

### Set job type to batch

The default Nomad job type is **service**. For a batch job, you need to explicitly add the type attribute to the **job** stanza.

```hcl
  type = "batch"
```

### Configure the task

Inside of the **task** stanza, add the following `config` stanza. This configuration uses the **cat** command to output a file named **out.txt** that this job creates.

```hcl
      config {
        command = "cat"
        args = ["local/out.txt]
      }
```

### Add a `template`

Next, add a **template** stanza inside the **task** stanza. This template will write the words `This is my template` to the **local/out.txt** file.

```hcl
      template {
        destination = "local/out.txt"
        data =<<EOT
This is my template.
EOT
      }
```

### Run the completed job

<Accordion heading="View a complete version of the job" collapse>

```hcl
job "template" {
  datacenters = ["dc1"]
  type = "batch"

  group "renderer" {
    task "output" {
      driver = "raw_exec"

      config {
        command = "cat"
        args = ["local/out.txt"]
      }

      template {
        destination = "local/out.txt"
        data =<<EOT
This is my template.
EOT
      }
    }
  }
}
```

</Accordion>

Run the job with the `nomad job run` command.

```shell-session
$ nomad job run template.nomad
==> Monitoring evaluation "fe273062"
    Evaluation triggered by job "template_render"
    Allocation "bbae901c" created: node "3e34dbcd", group "renderer"
==> Monitoring evaluation "fe273062"
    Allocation "bbae901c" status changed: "pending" -> "complete" (All tasks have completed)
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "fe273062" finished with status "complete"
```

View the output from the job by running the `nomad alloc logs` command on the allocation that Nomad created. In the preceding output, the allocation ID is "**bbae901c**."

```shell-session
$ nomad alloc logs bbae901c
This is my template.
```

## Parameterize the job

Add a `parameterized` stanza to the **job** stanza. This stanza instructs Nomad to store the job and wait for you to dispatch instances of it.

```hcl
  parameterized {
  }
```

An empty `parameterized` stanza creates a parameterized job that can't be customized, but allows you to dispatch the job when you would like to run it.

Before making the job parameterized, you will need to purge the original batch version. Run `nomad job stop` with the `-purge` flag on the `template` job.

```shell-session
nomad job stop -purge template
```

Run the parameterized version of the job.

```shell-session
$ nomad run template.v3.nomad
Job registration successful
```

Notice that the output doesn't show any scheduling activity—no evaluation or allocation information. You should expect this, since parameterized jobs are not run until they are dispatched.

### If you get an error

If you receive the following error, it indicates that you missed purging the non-parameterized version of the template job. Run `nomad job stop -purge template` to resolve it.

```shell-session
$ nomad job run template.nomad
Error submitting job: Unexpected response code: 500 (cannot update non-parameterized job to being parameterized)
```

Run the `nomad job status` command to verify your parameterized job is available for dispatch.

```shell-session
$ nomad job status
ID        Type                 Priority  Status   Submit Date
template  batch/parameterized  50        running  2021-04-11T22:01:45-04:00
```

## Dispatch the job

Run the `nomad job dispatch` command to dispatch an instance of the parameterized job.

```shell-session
$ nomad job dispatch template
Dispatched Job ID = template/dispatch-1618193196-1044eb97
Evaluation ID     = 00084465

==> Monitoring evaluation "00084465"
    Evaluation triggered by job "template/dispatch-1618193196-1044eb97"
    Allocation "c842df26" created: node "9e9342f5", group "renderer"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "00084465" finished with status "complete"
```

Examine the output of the command. There are some key differences from the typical output of the `nomad job run` command. Notice that Nomad generates a **Dispatched Job ID**. This ID is used to refer to this specific instance of the parameterized job, and they will show in the output of `nomad job status` as well.

The output also provides scheduling information. Collect the allocation ID from your output. In the above output it is "**c842df26**." As before, run the `nomad alloc logs` command for your allocation ID.

```hcl
$ nomad alloc logs c842df26
This is my template.
```

Parameterized jobs without variables can be used to provide a means for running a batch job without having to supply the job specification.

## Add a dispatch variable

Parameterized jobs also provide the ability to send variables as part of dispatching the job. These variables can be optional or required.

For example, the following parameterized stanza adds a required variable named `dispatcher_email` and an optional variable named `pager_email`.

```hcl
  parameterized {
    meta_required = ["dispatcher_email"]
    meta_optional = ["pager_email"]
  }
```

Add two variables to the template job's parameterized stanza—one required variable named `my_name` and an optional variable named `my_title`—by adding the following attributes inside the parameterized stanza.

```hcl
    meta_required = ["my_name"]
    meta_optional = ["my_title"]
```

### Add the variables to the template

Update the template content inside of the HEREDOC markers(`<<EOT`  and `EOT`). Replace it with the following content. Make sure that the ending HEREDOC delimiter is at the beginning of a line by itself.

```go
This is my template.
Hello {{ if ( env "NOMAD_META_MY_TITLE" ) }}{{ env "NOMAD_META_MY_TITLE" }} {{ end }}{{ env "NOMAD_META_MY_NAME" }}.
```

### Deploy and dispatch the job

```shell-session
$ nomad run template.nomad
Job registration successful
```

```shell-session
$ nomad job dispatch -meta my_name=Learner template
Dispatched Job ID = template/dispatch-1618195132-3d59eda3
Evaluation ID     = 0803be44

==> Monitoring evaluation "0803be44"
    Evaluation triggered by job "template/dispatch-1618195132-3d59eda3"
    Allocation "0f1c6c7a" created: node "9e9342f5", group "renderer"
==> Monitoring evaluation "0803be44"
    Allocation "0f1c6c7a" status changed: "pending" -> "complete" (All tasks have completed)
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "0803be44" finished with status "complete"
```

```shell-session
$ nomad alloc logs 0f1c6c7a
This is my template.
Hello Learner.
```

### Test that `my_name` is required

Because you put the `my_name` variable in the **meta_required** attribute's value list, the job will not run unless you provide it when dispatching. If you do not, you will receive an error. Try it now.

```shell-session
$ nomad job dispatch template
Failed to dispatch job: Unexpected response code: 500 (Dispatch did not provide required meta keys: [my_name])
```

### Use the optional variable

```shell-session
$nomad job dispatch -meta my_name=Learner -meta my_title=awesome template
Dispatched Job ID = template/dispatch-1618195957-6256077e
Evaluation ID     = fdfb6827

==> Monitoring evaluation "fdfb6827"
    Evaluation triggered by job "template/dispatch-1618195957-6256077e"
    Allocation "2b2ebdc1" created: node "9e9342f5", group "renderer"
==> Monitoring evaluation "fdfb6827"
    Allocation "2b2ebdc1" status changed: "pending" -> "complete" (All tasks have completed)
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "fdfb6827" finished with status "complete"
```

```shell-session
$ nomad alloc logs 2b2ebdc1
This is my template.
Hello awesome Learner.
```

### Set default values for optional variables

You set default values for optional variables by adding the `meta` stanza inside the **job** stanza. Create a default of "diligent" for `my_title` by adding the following meta stanza.

```hcl
  meta {
      my_title = "diligent"
  }
```

```shell-session
$ nomad job dispatch -meta my_name=Learner template
Dispatched Job ID = template/dispatch-1618196625-aa9ba981
Evaluation ID     = 999e5266

==> Monitoring evaluation "999e5266"
    Evaluation triggered by job "template/dispatch-1618196625-aa9ba981"
    Allocation "ea32501e" created: node "9e9342f5", group "renderer"
==> Monitoring evaluation "999e5266"
    Allocation "ea32501e" status changed: "pending" -> "complete" (All tasks have completed)
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "999e5266" finished with status "complete"```

```shell-session
$ nomad alloc logs ea32501e
This is my template.
Hello diligent Learner.
```

```shell-session
$ nomad job dispatch -meta my_name=Learner -meta my_title=fantastic template
Dispatched Job ID = template/dispatch-1618196752-eb39d032
Evaluation ID     = c9c455b3

==> Monitoring evaluation "c9c455b3"
    Evaluation triggered by job "template/dispatch-1618196752-eb39d032"
    Allocation "8c04f35c" created: node "9e9342f5", group "renderer"
==> Monitoring evaluation "c9c455b3"
    Allocation "8c04f35c" status changed: "pending" -> "complete" (All tasks have completed)
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "c9c455b3" finished with status "complete"
```

```shell-session
$ nomad alloc logs 8c04f35c
This is my template.
Hello fantastic Learner.
```

## Use dispatch payloads

```hcl
      dispatch_payload {
        file = "config.json"
      }
```
