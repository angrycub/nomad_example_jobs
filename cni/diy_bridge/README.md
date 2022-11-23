# DIY CNI bridge network

## About

This example uses a CNI configuration based on Nomad's internal CNI template
used to implement the `network_mode = "bridge"` behavior.

## Requirements

This demonstration requires a Linux Nomad client.

## Running

### Validate CNI plugins are installed

Generally you will install the CNI plugins as part of setting up a Nomad client,
so this step may already be complete. However, for development clients that
aren't using Nomad's `bridge` network mode, these might not have been installed.

Nomad clients look for CNI plugins in the path given in the client's [`cni_path`],
`/opt/cni/bin` by default. Check your client configuration to see if this value
has been overridden.

Check these folders for the CNI plugins. Verify that you have all the following binaries somewhere in the folders listed in your `cni_path`.

- `bridge`
- `firewall`
- `host-local`
- `loopback`
