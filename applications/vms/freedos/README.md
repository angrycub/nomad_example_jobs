## FreeDOS VM

This job fetches a small remote VM image and starts it in your Nomad cluster. It
also contains a task that starts a web-browser based VNC viewer.

TODO: This job requires network namespaces for QEMU, which currently does not
work in a released version of Nomad.
