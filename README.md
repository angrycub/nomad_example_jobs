# Nomad Example Jobs

This repository holds jobs and job skeletons that I have used to create
reproducers or minimum viable cases. I use them when creating guides as
simple workloads as well.

Some specifically useful bits:

- **csi** - Example jobs that use CSI to connect to external resources such as
  block devices.

- **fabio** - Several different fabio configurations that can be used to spin up
  consul-aware load balancing in your Nomad cluster.

- **sleepy** - Jobs that do a thing and then sleep (perhaps redoing the thing
  when they wake up).

- **template_playground** - a batch job that can be used to practice iterative
  template development.
  