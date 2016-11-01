#!/bin/bash

./configure --enable-debug --with-coroutine=gthread --prefix=/usr --disable-libssh2 --disable-tcmalloc --disable-glusterfs \
    --enable-seccomp --disable-{bzip2,snappy,lzo} --disable-usb-redir \
    --disable-libusb --disable-libnfs --disable-tcg-interpreter --disable-debug-tcg \
    --disable-libiscsi --disable-rbd --disable-spice --enable-attr \
    --enable-cap-ng --disable-linux-aio --disable-uuid --disable-brlapi \
    --disable-rdma --disable-bluez \
    --disable-fdt --disable-curl --enable-curses --disable-sdl \
    --disable-gtk --disable-tpm --disable-vte \
    --disable-xen --disable-opengl  --target-list=x86_64-softmmu

