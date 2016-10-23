#!/bin/sh

while [ 1 ] ; do
   slirpvde -dhcp -s $1 2> /dev/null;
   sleep 1;
done

