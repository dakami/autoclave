#!/bin/bash
DIR=/autoclave
cd $DIR
SOCK=$DIR/$RANDOM$RANDOM$RANDOM$RANDOM.sock
PIDFILE=$DIR/$RANDOM$RANDOM$RANDOM$RANDOM.pid
SLIRPPIDFILE=$DIR/$RANDOM$RANDOM$RANDOM$RANDOM.slirp.pid
VDESOCK=$DIR/$RANDOM$RANDOM$RANDOM$RANDOM.vde.sock
MONSOCK=$DIR/$RANDOM$RANDOM$RANDOM$RANDOM.mon.sock
vde_switch -s $VDESOCK -p $PIDFILE -d
VDEPID=`cat $PIDFILE`
rm -rf $PIDFILE
#slirpvde -s $VDESOCK -p $PIDFILE -d -dhcp
/root/sillyslirp.sh $VDESOCK &
SLIRPPID=$!
/usr/bin/qemu-system-x86_64 -localtime -drive file=/dev/shm/msedge.qcow2,if=ide -M pc-0.13 -cpu core2duo,+lahf_lm,+sse4.1,+xtpr,+cx16,+tm2,+est,+vmx,+ds_cpl,+pbe,+tm,+ht,+ss,+acpi,+ds  -enable-kvm -m 4G -uuid 0d60641a-67c1-4d83-a914-4118219bfea1 -vnc unix:$SOCK -vga qxl  -usbdevice tablet  -net nic -net vde,sock=$VDESOCK -object memory-backend-file,id=smem,size=4G,mem-path=/dev/shm/win10_memstate -snapshot -incoming "exec: cat /dev/shm/win10_devstate" -smp 4 -numa node,cpus=0-3,memdev=smem  -cdrom /autoclave/nonmem_images/virtio-win.iso -name whiteops-autoclave-win10edge-demo -pidfile $PIDFILE 2> /dev/null > /dev/null &
sleep 0.75
QEMUPID=`cat $PIDFILE`
#/root/nuker.sh $QEMUPID 2> /dev/null > /dev/null &
socat stdio unix-connect:$SOCK
kill -9 $QEMUPID
rm $PIDFILE
kill -9 $SLIRPPID
kill -9 $VDEPID
rm -rf $SOCK $VDESOCK $MONSOCK 


