# Docker Image Not Found

This folder containse examples that demonstrate what happens when a requested Docker image can not be found.  

* **restart.nomad** - contains a restart stanza that will cause this to restart infinitely on the same client
* **reschedule.nomad** - will utilize the defaults and reschedule onto other nodes in nomad 0.8+

