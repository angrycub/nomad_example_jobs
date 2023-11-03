FROM ubuntu

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y \
      qemu \
      qemu-utils \
      libguestfs-tools \
      linux-image-generic \
      nbdfuse \
      nbd-client \
      nbdkit \
      nbdkit-plugin-guestfs

RUN mkdir -p /mnt/cdrom /mnt/tinycore

