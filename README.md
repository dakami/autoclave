# AutoClave

# TL;DR

If you allow QEMU to set itself up, it really doesn't require much from the kernel.  So use seccomp-bpf to limit
a full empowered VM -- that can execute Linux, Windows, and probably OSX, along with whatever container you like -- to 
a handful of syscalls and memory maps.
