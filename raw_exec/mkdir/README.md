# Using mkdir

This example demonstrates using mkdir to create a few directories on the host before running a job.

- [mkdir.nomad](mkdir.nomad) - demonstrates the use of mkdir; however, it also illustrates that there is no bash expansion because there is no shell running to perform the expansion.

- [mkdir-bash.nomad](mkdir-bash.nomad) - corrects the job to allow the creation of multiple directories via shell expansion by starting a shell and _then_ calling mkdir.

