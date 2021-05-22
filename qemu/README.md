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

docker run -v $(pwd)/working:/working --privileged --name=imagebuilder --rm -it ubuntu /bin/bash

```
apt update;
apt install -y \
  qemu \
  qemu-utils \
  libguestfs-tools \
  linux-image-generic \
  nbdfuse \
  nbd-client
```

```
cd working
wget http://tinycorelinux.net/12.x/x86/release/Core-current.iso
mkdir /mnt/cdrom
mkdir /mnt/tinycore
mount Core-current.iso /mnt/cdrom


```

docker run -v $(pwd):/working --privileged --rm --name=imagebuilder -it imagebuilder /bin/bash



---------
```
qemu-img create -f qcow2 /working/core-image.qcow2 64M
qemu-nbd -c /dev/nbd0 /working/core-image.qcow2
```

```
fdisk /dev/nbd0
```

```
qemu-nbd -d /dev/nbd0
```

guestfish -a /working/core-image.qcow2

```
run


```
qemu-img create -f qcow2 /working/core-image.qcow2 64M
mkdir -p /block
nbdfuse /block/nbd0 --socket-activation qemu-nbd -f qcow2 /working/core-image.qcow2 & 
```

```
fusermount3 -u dir
rmdir dir
```



---
```
guestfish -N core-image.qcow2=fs:ext4:64M:mbr exit
guestmount -a /working/core-image.qcow2 -m /dev/sda1 /mnt/tinycore


rm -rf /mnt/tinycore/lost+found
mkdir -p /mnt/tinycore/boot
mkdir -p /mnt/tinycore/tce/optional
touch /mnt/tinycore/tce/onboot.lst
grub-install --boot-directory=/mnt/tinycore/boot
cp /mnt/cdrom/boot/vmlinuz
```
