## Nomad Example using GCP Persistent Disk CSI Plugin

Source Repo: https://github.com/kubernetes-sigs/gcp-compute-persistent-disk-csi-driver 

### Create a persistent disk

Nomad does not handle disk creation and expects this to be done by an operator.

### Edit the disk.hcl file

Once the Disk is created, edit the disk.hcl file and replace the placeholder
(`«disk id as listed in the GCP Disks page»`) with the disk ID
found in the GCP interface.

### Run an agent to test

You are now ready to run the node job, register the volume, and run the workload.

You can use a dev agent to test; however, you will need to pass in additional
configuration to allow the Docker driver to run privileged containers. This is
a requirement to allow the CSI plugin containers to mount and unmount storage.

There is a config.nomad that has the necessary configuration. Start an agent by
running:

```shell
$ nomad agent -dev -config=config.nomad
```

For full clusters, verify that your clients have the appropriate permission
configured for the docker plugin. Once properly configured, you will be able to
run the node.nomad file, wait for the plugins to become healthy, register the
volume, and then run the job.nomad file.

### Use nomad alloc exec to check the mount

You can connect to the mounted container by running `nomad alloc exec` for the
allocation of the workload. For example.

```shell
$ nomad alloc exec ac345h /bin/sh
```

This will give you a shell prompt inside of the container. If you list the `/srv`
directory, you should see a lost+found directory. This indicates that you are at
the base of an ext filesystem and shows that your block device was mounted into
your container there.

```shell
# ls /srv
.       ..      lost+found
```
