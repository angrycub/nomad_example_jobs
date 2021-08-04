# HCL2 Conditionals

This sample job demonstrates using HCL2 variables to submit a job containing an
appropriate workload for running on Linux Nomad clients or Windows Nomad
clients. 

In this case, the created job runs a Nomad `template` (included using the HCL2
`file()` function) and uses either Powershell's `Get_Content` or the Linux
`cat` command to emit the file to STDOUT. You can then fetch the output using
the `nomad alloc logs` command to pull the allocation's log.

## Variables

The Nomad job provides the following HCL2 variables:

- `driver` — [`exec`, `raw_exec` default:`raw_exec`] The task driver to use for
  running the output task.

- `datacenter` — [string default:`dc1`] Allows a user to set the datacenter to
  run the job in via variable rather than a constant.

- `os` — [`windows`,`linux`,`macos` default:`linux`] - The selector that
  determines which command to submit as the `command` and `args` for the
  `output` task. Currently all non-`windows` workloads use the `linux` values
  for `args` and `command`

### Setting Variables

Variables can be set as environment variables, flags, and in and variables files.

- As environment variables, for example: `NOMAD_VAR_foo=bar`.
- Individually, with the `-var foo=bar` command line option.
- In variable definitions files specified on the command line (with `-var-file=input.vars`).

#### Complex-typed Values

When variable values are provided in a variable definitions file, Nomad's usual
syntax can be used to assign complex-typed values, like lists and maps.

### Precedence

Nomad loads variables in the following order, with later sources taking
precedence over earlier ones.

- Environment variables (lowest priority)
- Any -var and -var-file options on the command line, in the order they are
provided. (highest priority)

## Running

```shell
$ nomad job run -var os=macos -var driver=raw_exec template.nomad
==> 2021-08-04T13:57:08-04:00: Monitoring evaluation "acb82456"
    2021-08-04T13:57:08-04:00: Evaluation triggered by job "template"
==> 2021-08-04T13:57:09-04:00: Monitoring evaluation "acb82456"
    2021-08-04T13:57:09-04:00: Allocation "b7659a49" created: node "044d5c30", group "renderer"
    2021-08-04T13:57:09-04:00: Evaluation status changed: "pending" -> "complete"
==> 2021-08-04T13:57:09-04:00: Evaluation "acb82456" finished with status "complete"

$ nomad alloc logs b7659a49
                 node.unique.id: 044d5c30-6913-f0ec-863f-30be20212489
                node.datacenter: dc1
               node.unique.name: nomad-client-1
...

```


