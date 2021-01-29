# TinyCore QEMU example

This sample will start a TinyCore Linux VM configured with the SSH daemon
enabled. It performs port forwarding using the QEMU commands so that Nomad can
dynamically assign a HTTP and SSH port for the VM.

You will need to serve the `tinycore.qcow2` image someplace so that it can be
retrieved using the artifact stanza.

