# Fabio Jobs

>Fabio is an HTTP and TCP reverse proxy that configures itself with data from
Consul.
>
>Traditional load balancers and reverse proxies need to be configured with a
config file. The configuration contains the hostnames and paths the proxy is
forwarding to upstream services. This process can be automated with tools like
consul-template that generate config files and trigger a reload.
>
>Fabio works differently since it updates its routing table directly from the
data stored in Consul as soon as there is a change and without restart or
reloading.

More information about Fabio can be found at the project's website: <https://fabiolb.net/>

## The job specifications

- `fabio-docker.nomad` - A Nomad system job that uses the Docker task driver to
  run the `latest` tag of the container. This configuration simplifies locating
  a fabio instance from an external loadbalancer like an ELB. Simplest way to
  get started with Fabio.

- `fabio-system.nomad` - A Nomad system job that uses the exec task driver to
  run instances of the Fabio 1.5.15 linux/amd64 binary on all the linux/amd64
  clients in your cluster. This configuration simplifies locating a fabio
  instance from an external loadbalancer like an ELB.

- `fabio-service.nomad` - A Nomad service job that uses the exec task driver to
  run three instances of the Fabio 1.5.15 linux/amd64 binary. This configuration
  requires a load balancer capable of inspecting Consul or testing the Fabio
  ports over all of the clients to identify where the Fabio instances landed.

