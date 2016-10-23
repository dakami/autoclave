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
/root/sillyslirp.sh $VDESOCK &
SLIRPPID=$!
#ttu -b 0.0.0.0:5900=$SOCK,0.0.0.0:5700=$WEBSOCK --
echo "c" | /usr/bin/qemu-system-x86_64 -name whiteops-autoclave-chromium-demo \
    -net nic -net user \
    -enable-kvm  -vga qxl \
    -smp 48 \
    -vnc unix:$SOCK,lossy \
    -object memory-backend-file,id=smem,size=64G,mem-path=/dev/shm/linux_memstate \
    -numa node,cpus=0-47,memdev=smem \
    -m 64G \
    -snapshot \
    -hda /dev/shm/boot.qcow2 \
    -hdb ~/empty.qcow2 \
    -incoming "exec: cat /dev/shm/linux_devstate" \
    -pidfile $PIDFILE \
    -global kvm-apic.vapic=false -global qxl-vga.revision=4 \
    -monitor unix:$MONSOCK,server,nowait \
    2> /dev/null > /dev/null &
#/usr/bin/qemu-system-x86_64 -pidfile $PIDFILE -name whiteops-autoclave-demo -net nic -net vde,sock=$VDESOCK -enable-kvm -cdrom /dev/shm/ub.iso -vga qxl -smp 2 -vnc unix:$SOCK,lossy -object memory-backend-file,id=smem,size=128G,mem-path=/dev/shm/linux_memstate,share=on -numa node,cpus=0-1,memdev=smem  -cpu host  -vga qxl -m 128G  -global kvm-apic.vapic=false 2> /dev/null > /dev/null &
#-incoming "exec: cat /dev/shm/linux_devstate" -pidfile $PIDFILE 2> /dev/null > /dev/null &
sleep 0.75
QEMUPID=`cat $PIDFILE`
#/root/nuker.sh $QEMUPID &
echo "c" | socat stdio unix-connect:$MONSOCK 2> /dev/null > /dev/null
socat stdio unix-connect:$SOCK
kill -9 $QEMUPID
rm $PIDFILE
kill -9 $SLIRPPID
kill -9 $VDEPID
rm -rf $SOCK $VDESOCK $MONSOCK 


