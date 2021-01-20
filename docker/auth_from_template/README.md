# Auth from Template Example

This job specification demonstrates using the `template` stanza to create
environment variables suitable for Nomad to use in variable interpolation.

This example uses Consul KV, since there is less configuration necessary to
run the sample; however, this exists to demonstrate that a Vault-based solution
(once configured with your cluster) would be trivial to switch to.

This job pairs with the docker_registry_v2 job from the applications folder,
which has basic authentication enabled. Once you have started it, you will need
to pull the redis:latest image from DockerHub and push it into your local repo.


### Add the values for the job to Consul

```shell-session
$ consul kv put consul kv put kv/docker/config/user user
$ consul kv put consul kv put kv/docker/config/pass securepassword
```

Running the job will start as expected. Stop the job.

### Add the values for the job to Consul

```shell-session
$ consul kv put consul kv put kv/docker/config/pass securepasswordLOL
```

Running the job now will fail since the credential is invalid.




