# AutoClave

# TL;DR
If you allow QEMU to set itself up, it really doesn't require much from the kernel.  So use seccomp-bpf to limit
a full empowered VM -- that can execute Linux, Windows, and probably OSX, along with whatever container you like -- to 
a handful of syscalls and memory maps.

Also if you do some clever things with memory management you can boot an arbitrarily
complex environment *subsecond*, with memory deduplication *in a safe context* 
(no user data, only leaks what a dev puts in).  Maybe we don't need Unikernels,
to give known good state to every user coming in.

# Quick Demo

https://autoclave.run has a pretty good demonstration of the ultimate vision here,
but here's some quick steps to get up and running yourself.

(This is very early, only supporting firewall-on-VNC connection in this patchset)

(No, I haven't tested this yet.  RELENG!)

    # apt-get install vde2 libvde-dev libvdeplug-dev libseccomp-dev git
    ### You need to add deb-src for deb line in /etc/apt/sources.list,
    ### because Reasons
    # apt-get update
    # apt-get build-dep qemu
    # git clone http://git.qemu.org/git/qemu.git
    # cd qemu
    # for i in ../patches/*; do patch -p1 < $i; done
    # ./configure --prefix=/usr --enable-vde --enable-seccomp --target-list=x86_64-softmmu
    # make
    # make install
    ### Easily the most dangerous thing going on, assuming you're running
    ### a multiuser system with users who aren't coming in through Autoclave.
    ### Assuming.
    # chmod 0777 /dev/kvm 

    ### Now, you don't need to be root for actual execution:
    $ vde_switch -d -s user.sock
    $ slirpvde -d -dhcp -s user.sock
    $ wget http://mirrors.xmission.com/linuxmint/iso//stable/18/linuxmint-18-mate-64bit.iso 
    $ qemu-system-x86_64 -cdrom linuxmint-18-mate-64bit.iso -m 4G -vnc :25,lossy -net nic -net \
      vde,sock=user.sock -global kvm-apic.vapic=false -smp 4,sockets=2,cores=2,threads=1 \
      -vga qxl -enable-kvm -monitor stdio
    QEMU 2.7.50 monitor - type 'help' for more information
    (qemu) migrate "exec: ls"
    (qemu) 
    ### Yes, arbitrary code execution in QEMU Hypervisor Shell works like this :)
    ### If you've got a VNC link, Control Alt 2 is often full of surprises.
    ### Drop the monitor element and you get this through VNC.
    ### But now, let's connect.  (TODO, insert nice pretty screenshot.)
    (qemu) migrate "exec: ls"
    Unable to open /dev/null: Permission denied


    

    
# TODO

1. Comprehensively document the exposed syscalls, memory maps, and file handles
2. Modify QEMU to reduce #1 to bare minimums, at least for specified performance levels
3. Manage exposure of /dev/kvm to untrusted users, modifying the module if necessary
4. Integrate dirtycow exploit into QMP, so we can see whether KVM_RUN semantics
   do or do not suppress thread races
5. Determine whether snapshot/loadvm conflict is resolved in QEMU Master, and if not,
   integrate patches.
6. Move apply_autoclave out of vnc.c (sigh) and into somewhere it can be called,
   somewhat generically, either right before VM start (in vl.c) or on network
   connection (vnc and spice)
7. Dive back into the monolithic beast that is libvirt, because we actually do
   want to work with the rest of the ecosystem
8. Figure out proper performance engineering, use of hugepages (explicit/transparent/
   blocked).
9. Finish extraction and demonstration to level of https://autoclave.run, i.e. actually
   show use of bypass_shared_memory
10. Make https://autoclave.run a thing that is scalable
11. Make Autoclave work well under nested virtualization, or at least understand
    what that would take (probably guarantees around linearized memory mapping)
12. Resolve precisely when xinetd should receive a VNC connection string, rather
    than just spitballing it.  Connections trigger the autoclave lockdown, so
    this does matter.
13. Integrate with Intel Clear Containers
14. Integrate with Docker
15. Map out how to host web servers like Guacamole, instead of VNC/Spice like
    interfaces.
15. Expand this document!