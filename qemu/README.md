# TinyCore QEMU example

This sample will start a TinyCore Linux VM configured
with the SSH daemon enabled. It performs port forwarding
using the QEMU commands so that Nomad can dynamically
assign a HTTP and SSH port for the VM.

You will need to serve the image someplace so that it
can be retrieved using the artifact stanza.

Creating the image

Download the boot image - <http://tinycorelinux.net/12.x/x86/release/Core-current.iso>

<https://fabianstumpf.de/articles/tinycore_images.htm> Original article

docker run -v $(pwd):/working --privileged -it ubuntu /bin/bash

```
apt update;
apt install -y \
  qemu \
  qemu-utils \
  libguestfs-tools \
  linux-image-generic
```

```
cd working
wget http://tinycorelinux.net/12.x/x86/release/Core-current.iso
mkdir /mnt/cdrom
mkdir /mnt/tinycore
mount Core-current.iso /mnt/cdrom
qemu-img create -f qcow2 core-image.qcow2 64M
```
guestmount -a /working/core-image.qcow2 -i /mnt







---------


```
nbd-server 1043 /working/core-image.img 
```

```
nbdfuse /working/core-disk nbd://localhost
```


nbdfuse block/disk.raw \
   --socket-activation qemu-nbd -f qcow2 core-image.img & 
