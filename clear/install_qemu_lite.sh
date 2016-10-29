#!/bin/bash
cat /etc/apt/sources.list | sed 's/deb /deb-src /g' > /etc/apt/sources.list.d/sources.list
apt-get update

apt-get -y build-dep qemu

git clone https://github.com/01org/qemu-lite.git
cd qemu-lite
git checkout qemu-2.7-lite
git reset --hard qemu-2.7-lite
cp -p ../blobs/qemu-config.sh .
patch -p1 < ../../patches_to_be_migrated/vl_autoclave.patch
./qemu-config.sh
make
make install
rm /usr/bin/qemu-lite-system-x86_64 /usr/bin/qemu-lite-ga /usr/bin/virtfs-lite-proxy-helper
ln -s /usr/bin/qemu-system-x86_64 /usr/bin/qemu-lite-system-x86_64
ln -s /usr/bin/qemu-ga /usr/bin/qemu-lite-ga
ln -s /usr/bin/virtfs-proxy-helper /usr/bin/virtfs-lite-proxy-helper
chmod 0777 /dev/kvm # yeah, I know


