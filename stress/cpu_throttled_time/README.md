## cpu_throttled_time

This job demonstrates the nomad.client.allocs.cpu.throttled_time metric by providing a CPU-constrained docker environment and runnign stress inside of it.

You will need to have allocation metrics enabled on your Nomad clients:

```
telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
```


