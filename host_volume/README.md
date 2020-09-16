## Host Volume Examples

These sample job files will exercise a simple host volume configuration.  They assume that the following
volumes are configured somewhere in your cluster:

```hcl
host_volume "certs" {
  path      = "/data/certs"
  read_only = "true"
}

host_volume "mysql" {
  path      = "/data/mysql"
  read_only = "false"
}

host_volume "prometheus" {
  path      = "/data/prometheus"
  read_only = "false"
}

host_volume "templates" {
  path      = "/data/templates"
  read_only = "true"
}
```
