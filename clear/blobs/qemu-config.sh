#!/bin/bash

./configure --prefix=/usr --disable-libssh2 --disable-tcmalloc --disable-glusterfs \
    --enable-seccomp --disable-{bzip2,snappy,lzo} --disable-usb-redir \
    --disable-libusb --disable-libnfs --disable-tcg-interpreter --disable-debug-tcg \
    --disable-libiscsi --disable-rbd --disable-spice --enable-attr \
    --enable-cap-ng --disable-linux-aio --disable-uuid --disable-brlapi \
    --disable-vnc-{jpeg,png,sasl} --disable-rdma --disable-bluez \
    --disable-fdt --disable-curl --disable-curses --disable-sdl \
    --disable-gtk --disable-tpm --disable-vte --disable-vnc \
    --disable-xen --disable-opengl --disable-slirp --target-list=x86_64-softmmu

