# Nomad CNI examples

This folder contains Nomad job specifications and configuration files that show
how Nomad can use [Container Network Interface (CNI)](https://cni.dev) plugins
and network configurations for running workloads.

## Examples

- [`diy_bridge`](diy_bridge) - Create your own bridge network similar to the one Nomad makes
  for `network_mode = "bridge"` jobs.
