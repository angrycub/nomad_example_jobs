path "auth/token/lookup-self"     { capabilities = ["read"]   }
path "auth/token/lookup"          { capabilities = ["update"] }
path "auth/token/revoke-accessor" { capabilities = ["update"] }
path "sys/capabilities-self"      { capabilities = ["update"] }
path "auth/token/renew-self"      { capabilities = ["update"] }

path "auth/token/create/nomad-cluster" { capabilities = ["update"] }
path "auth/token/roles/nomad-cluster"  { capabilities = ["read"]   }

path "auth/token/create/nomad-aaa" { capabilities = ["update"] }
path "auth/token/roles/nomad-aaa"  { capabilities = ["read"]   }


