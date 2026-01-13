# Connect Discuss Example

This example demonstrates Consul Connect service mesh integration with Nomad using a blocky DNS configuration.

## Prerequisites

- Consul Connect enabled on your cluster
- Nomad configured with Consul integration

## Usage

Run the job from this directory so the `file()` function can find `blocky.yaml`:

```bash
cd connect/discuss
nomad job run job.nomad
```

## Configuration

The job uses an HCL2 variable `config_data` which defaults to `blocky.yaml`. You can override it:

```bash
nomad job run -var="config_data=/path/to/custom.yaml" job.nomad
```

## Files

- `job.nomad` - The Nomad job specification
- `blocky.yaml` - Configuration file for the blocky DNS service
