#!/bin/bash

apt-get update
apt-get -y install libpixman-1-0

sh -c "echo 'deb http://download.opensuse.org/repositories/home:/clearlinux:/preview:/clear-containers-2.0/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/cc-oci-runtime.list"


wget http://download.opensuse.org/repositories/home:clearlinux:preview:clear-containers-2.0/xUbuntu_16.04/Release.key
apt-key add Release.key
rm Release.key

apt-get update
apt-get -y install cc-oci-runtime

apt-get update
apt-get install apt-transport-https ca-certificates
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sh -c "echo 'deb https://apt.dockerproject.org/repo ubuntu-xenial main' > /etc/apt/sources.list.d/docker.list"
apt-get update
apt-get purge lxc-docker
apt-cache policy docker-engine
apt-get -y install docker-engine=1.12.1-0~xenial

pushd /usr/share/clear-containers/
rm clear-containers.img
ln -s clear-*-containers.img clear-containers.img
sed -ie 's!"image":.*$!"image": "/usr/share/clear-containers/clear-containers.img",!g' /usr/share/defaults/cc-oci-runtime/vm.json
popd

mkdir -p /etc/systemd/system/docker.service.d/
cp blobs/clr-containers.conf /etc/systemd/system/docker.service.d/

systemctl daemon-reload
systemctl restart docker






