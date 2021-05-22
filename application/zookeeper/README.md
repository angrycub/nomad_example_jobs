# Deploy Zookeeper on Nomad

## Challenge

Installing Apache Zookeeper (ZK) in a Nomad cluster can be challenging because

- Zookeeper requires persistent storage
- The IP configuration needs to be dynamic

## Solution

Nomad's host volume feature allows you to mount a directory on the Nomad client to an allocation to provide persistent storage to workloads.

Using Nomad's HCL2 job specification, you can create a declarative job
specification that can create the dynamic node configuration required for each
Zookeeper instance.

## Requirements

- Nomad 1.1.0+
- Consul

## Build a single-node ZK configuration

Start with a simple Docker job that runs a Zookeeper container.



```hcl
job "zookeeper" {
  datacenters = ["dc1"]
  type = "service"

      config {
        image = "zookeeper:3.6.1"

        ports = ["client","peer","election","admin"]
        volumes = [
          "config:/config",
          "config/zoo.cfg:/conf/zoo.cfg"
          ]
      }

      resources {
        cpu = 300
        memory = 256
      }
    }
  }
}

```
