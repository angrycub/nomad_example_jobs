README

This example demonstrates using the Consul service mesh
to connect a workload to the Consul DNS query API

## Connect Consul DNS API to the mesh

### Deploy Consul service

Create a service on the Consul server node. Create a service
definition with the following information.

```hcl
service {
  name = "consul-dns"
  id = "consul-dns-1"
  port = 8600

  connect {
    sidecar_service {}
  }
}
```

### Start a sidecar for the Consul DNS query API

```
$ consul connect proxy -sidecar-for consul-dns-1
```

## Test the connection

Use a local connect proxy to test whether or not the
service is accessible via the proxy.

Start a local connect proxy.

```
$ consul connect proxy -service charlie -upstream consul-dns:8600 
```

Verify the connection
