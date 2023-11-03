# Some notes that need to be formatted and properly attended to

You will need to serve the image someplace so that it
can be retrieved using the artifact stanza.

## Creating the image

Download the boot image - <http://tinycorelinux.net/12.x/x86/release/Core-current.iso>

<https://fabianstumpf.de/articles/tinycore_images.htm> Original article

docker run -v $(pwd)/working:/working --privileged --name=imagebuilder --rm -it ubuntu /bin/bash

```bash
apt update;
apt install -y \
  qemu \
  qemu-utils \
  libguestfs-tools \
  linux-image-generic \
  nbdfuse \
  nbd-client
```

```bash
cd working
wget http://tinycorelinux.net/12.x/x86/release/Core-current.iso
mkdir /mnt/cdrom
mkdir /mnt/tinycore
mount Core-current.iso /mnt/cdrom
```

```
docker run -v $(pwd):/working --privileged --rm --name=imagebuilder -it imagebuilder /bin/bash
```

### Using qemu-img to make the disk

This requires a nbd-capable kernel so that you can mount the qcow as a block
device for more standard manipulation

Create the qcow and create the block device for it with `qemu-nbd`
```bash
qemu-img create -f qcow2 /working/core-image.qcow2 64M
qemu-nbd -c /dev/nbd0 /working/core-image.qcow2
```

Create a partition table

```bash
fdisk /dev/nbd0
```

Remove the NBD device

```bash
qemu-nbd -d /dev/nbd0
```

```bash
guestfish -a /working/core-image.qcow2
```

run

### Using nbdfuse for systems that don't have kernel nbd support

```bash
qemu-img create -f qcow2 /working/core-image.qcow2 64M
mkdir -p /block
nbdfuse /block/nbd0 --socket-activation qemu-nbd -f qcow2 /working/core-image.qcow2 &
```

```bash
fusermount3 -u dir
rmdir dir
```

### Using guestfish tools to build an image

```bash
guestfish -N core-image.qcow2=fs:ext4:64M:mbr exit
guestmount -a /working/core-image.qcow2 -m /dev/sda1 /mnt/tinycore
```


## Prepare image

```bash
rm -rf /mnt/tinycore/lost+found
mkdir -p /mnt/tinycore/boot
mkdir -p /mnt/tinycore/tce/optional
touch /mnt/tinycore/tce/onboot.lst
grub-install --boot-directory=/mnt/tinycore/boot
cp /mnt/cdrom/boot/vmlinuz
```
