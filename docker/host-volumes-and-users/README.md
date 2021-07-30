# Use `user` with Docker and a Nomad Host Volume

It is possible to use users with Nomad's Docker task driver. This can be coupled with Nomad host volumes
to provide more complex file access permissions to your workloads and to share files across them.


## Requirements

- a client with a host volume named `scratch`

- in the backing directory

  - create a directory named `2001`
  - change owner to `2001`
  - change permissions to `700`

  - create a directory named `2002`
  - change owner to `2002`
  - change permissions to `700`

  - create a directory named `world`
  - change permissions to `777`


## The scenario

### Run the job

```
nomad job run scratch.nomad
```

### Make an ALLOCATION_ID environment variable

```
export ALLOCATION_ID=«allocation id from the output above»
```

### Connect to the job

```
nomad alloc exec -task=2001 $ALLOCATION_ID /bin/sh
```


