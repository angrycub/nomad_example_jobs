# Using Task Lifecycle and Templates

The idea here is to have an init task that can block
until a value can be obtained from _somewhere_ (a Consul
KV key, a Nomad variable, a Vault secret). This value is
then written as an env style file into the shared alloc
dir to be picked up by the `main` task's template block
to be converted into env vars.


