# AutoClave

# TL;DR

If you allow QEMU to set itself up, it really doesn't require much from the kernel.  So use seccomp-bpf to limit
a full empowered VM -- that can execute Linux, Windows, and probably OSX, along with whatever container you like -- to 
a handful of syscalls and memory maps.

# Quick Demo

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


    

    
    