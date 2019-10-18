## Meta Interpolation

This example attempts to perform interpolation in the meta stanza which as of Nomad 0.10 does not work.

You can run this example in your cluster and then run:

```console
$ nomad alloc exec «allocation id» /bin/sh -c env
```

The goal is to have the two variables to contain the same data, however:

```text
ENV_TEST_INTERPOLATION=dc1-meta-stanza-test-job
TEST_INTERPOLATION={{ env NOMAD_DC }}-{{ env NOMAD_JOB_NAME }}
```

