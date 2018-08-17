## Zookeeper

This is a sample job that will provide a _reasonable_ configuration for Zookeeper on Nomad.  Realistically, there are some caveats here that should be covered by other locking semantics.

This _should_ survive a rolling upgrade as well.  It is not expected to be able to work with canary deployments though.

