#!/bin/bash
echo "Breaking the 'nomad-cluster' role"
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.broken.json
