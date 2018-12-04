## Docker Windows Absloute Path Bind Mount

**Summary:** This job will attempt to create a bind mount using the source/destination form of bind mounting with the `mount` stanza.  The continer will start a powershell script that writes a debug log into the mounted folder.  This file is then accessible from the host.

**Issue:** The Docker `-v` style mount option can not handle Windows absolute paths because of the ambiguity around the `:` as a seperator.

The included [Dockerfile](Dockerfile) was used to create `voiselle/sleepyecho:1.1`