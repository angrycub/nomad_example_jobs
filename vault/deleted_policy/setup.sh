#!/bin/bash
wait() {
	read -n 1 -s -r -p "
Press any key to continue..."
	echo ""
}

cuteSleep() {
    echo -n "Sleeping for $1 seconds"
    for i in $(seq 1 ${1})
    do
        echo -n "."
        sleep 1
    done
    echo ""
}

export VAULT_ADDR=http://127.0.0.1:8200
echo "Starting Vault Dev Server"
vault server -dev &>vault.log &
VAULT_PID=$!
echo "Started Vault Dev Server (pid ${VAULT_PID})"
cuteSleep 2
# Write the policy to Vault
echo "Creating the vault policies..."
echo "  'nomad-server'"
vault policy write nomad-server nomad-server-policy.hcl
echo "  'nomad-client'"
vault policy write nomad-client nomad-server-policy.hcl
echo "  'my-cool-policy'"
vault policy write my-cool-policy nomad-server-policy.hcl

# Create the token role with Vault
echo "Creating the 'nomad-cluster' role"
vault write /auth/token/roles/nomad-cluster @nomad-cluster-role.json

vault token create -policy nomad-server -period 10m -orphan | tee > nomad-server.token.out
grep -e "^token " nomad-server.token.out | awk '{print $2}' | tr -d '\n' > nomad-server.token
DATA_DIR=`pwd`/data
nomad agent -dev -vault-enabled=true -data-dir=${DATA_DIR} -vault-address="http://127.0.0.1:8200" -vault-token="`cat nomad-server.token`" -vault-create-from-role=nomad-cluster &>nomad.log &
NOMAD_PID=$!
echo "Started Nomad Dev Server (pid ${NOMAD_PID})"
cuteSleep 8


wait
echo "Killing Nomad Dev Server (pid ${NOMAD_PID})"
kill ${NOMAD_PID}
echo "Killing Vault Dev Server (pid ${VAULT_PID})"
kill ${VAULT_PID}
echo "Cleaning up data directory."
rm -rf ${DATA_DIR}