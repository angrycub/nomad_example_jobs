# Using environment variables as arguments

This example sets environment variables in a container's
ENTRYPOINT. It then runs a command that consumes them.

The Dockerfile in the project can be used to create an
`alpine` based container with simple shell scripts to
test the case.

The `start.nomad` file demonstrates the basic behavior and
can be used to prove that your container image path is
set correctly and that the scenario is built properly.

You will need to change the image paths in the job files
to match _**your specific image path**_ in both `start.nomad` and `test.nomad`.

Run the start job to validate the basics.

```text
$ nomad job run start.nomad
==> 2022-11-22T17:57:01-05:00: Monitoring evaluation "86382659"
    2022-11-22T17:57:01-05:00: Evaluation triggered by job "example"
    2022-11-22T17:57:02-05:00: Allocation "4691273a" created: node "d18649d1", group "g1"
    2022-11-22T17:57:02-05:00: Evaluation status changed: "pending" -> "complete"
==> 2022-11-22T17:57:02-05:00: Evaluation "86382659" finished with status "complete"
```

Note from the output that the created allocation's ID starts with 469. Your allocation ID will vary. Use that with the `nomad alloc logs` command to get the output from the latest run.

```text
$ nomad alloc logs 469
VAR1=foo
VAR2=bar
```

The `test.nomad` file shows overriding the command with
an alternative command inside the container and passing
environment variables that are set in the ENTRYPOINT.

The job sets both values to `$VAR2` to show that
they are still being read from the environment.

```text
$ nomad job run test.nomad
==> 2022-11-22T17:57:19-05:00: Monitoring evaluation "c0a0a83f"
    2022-11-22T17:57:19-05:00: Evaluation triggered by job "example"
    2022-11-22T17:57:20-05:00: Allocation "63800968" created: node "d18649d1", group "g1"
    2022-11-22T17:57:20-05:00: Evaluation status changed: "pending" -> "complete"
==> 2022-11-22T17:57:20-05:00: Evaluation "c0a0a83f" finished with status "complete"
```

Note from the output that the created allocation's ID starts with 638. Your allocation ID will vary. Use that with the `nomad alloc logs` command to get the output from the latest run.

```text
$ nomad alloc logs 638
It's the alternate version! 🎉
VAR1=bar
VAR2=bar
```
