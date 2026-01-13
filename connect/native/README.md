# Connect Native Example

This example demonstrates Consul Connect Native services with Nomad.

## Overview

Connect Native allows applications to natively integrate with the Consul Connect service mesh without requiring a sidecar proxy. The application itself handles mTLS communication.

## Prerequisites

- Consul Connect enabled on your cluster
- Nomad configured with Consul integration
- The Docker images must be available:
  - `hashicorpnomad/uuid-api:v3`
  - `registry.service.consul:5000/uuid-fe:latest` (or modify to use `hashicorpnomad/uuid-fe:v3`)

## Services

- **uuid-api**: Backend API service that generates UUIDs
- **uuid-fe**: Frontend service that calls the uuid-api upstream

## Usage

```bash
nomad job run cn-demo.nomad
```

The frontend will be available on port 25000.
