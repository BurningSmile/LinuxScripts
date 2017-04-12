#!/bin/zsh

#Load virtio
sudo modprobe virtio

#Load uefi
cp /usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd /tmp/my_vars.fd

#Start Vm
qemu-system-x86_64 \
       -enable-kvm \
       -boot order=c \
       -drive file=/home/david/virtual_machines/Windows10/Windows10disk,format=raw \
       -m 4G \
       -cpu host \
       -smp 4,cores=2,threads=2,sockets=1 \
       -mem-prealloc \
       -usbdevice tablet \
       -vga qxl\
       -soundhw hda \
       -drive if=pflash,format=raw,readonly,file=/usr/share/edk2.git/ovmf-x64/OVMF_CODE-pure-efi.fd \
       -drive if=pflash,format=raw,file=/tmp/my_vars.fd \
       -spice port=3001,disable-ticketing \
       -device virtio-serial \
       -chardev spicevmc,id=vdagent,debug=0,name=vdagent \
       -device virtserialport,chardev=vdagent,name=com.redhat.spice.0
       "$@"
