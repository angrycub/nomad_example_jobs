## Rolling Upgrades

This sample demonstrates the behavior of rolling upgrades in a Nomad cluster. 

Instructions:

Run the sample job:

```
nomad run example.nomad
```

This will deploy three instances of the sample redis container to the cluster.

Upgrade the instances:

```
nomad run example-new.nomad
```

Nomad should perform a rolling upgrade of the three instances.  It should wait for an instance to be healthy for one minute before moving to the next instance.

> **NOTE:** The example job is currently sad and will not upgrade properly.  The cv version presents an alternative configuration file structure that upgrades as expected.

