## Using Consul-Template to fake Task Dependencies

The consul-template library has a blocking behavior in the instances that a key does not yet exist in Consul.  This can be ~~abused~~ leveraged to allow for some light coordination between dependent Nomad tasks.  This would only work in instances where you were able to write to Consul from your workload once you entered the ready state or had a coordinating task that could perform this work based on some sort of application health check.
