#!/bin/bash

#Load virtio
sudo modprobe virtio

#Load uefi
cp /usr/share/edk2.git/ovmf-x64/OVMF_VARS-pure-efi.fd /tmp/my_vars.fd

# Load network bridge on eno1 interface
sudo /home/david/.scripts/Virtual-Machines/qemu-bridge-ifup.sh

#Start Vm
qemu-system-x86_64 \
       -enable-kvm \
       -boot order=c \
       -drive file=/home/david/virtual-machines/Windows-10/Windows10disk,format=raw \
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
       -device virtserialport,chardev=vdagent,name=com.redhat.spice.0 \
	-device ich9-usb-ehci1,id=usb \
	-device ich9-usb-uhci1,masterbus=usb.0,firstport=0,multifunction=on \
	-device ich9-usb-uhci2,masterbus=usb.0,firstport=2 \
	-device ich9-usb-uhci3,masterbus=usb.0,firstport=4 \
	-chardev spicevmc,name=usbredir,id=usbredirchardev1 \
	-device usb-redir,chardev=usbredirchardev1,id=usbredirdev1 \
	-chardev spicevmc,name=usbredir,id=usbredirchardev2 \
	-device usb-redir,chardev=usbredirchardev2,id=usbredirdev2 \
	-chardev spicevmc,name=usbredir,id=usbredirchardev3 \
	-device usb-redir,chardev=usbredirchardev3,id=usbredirdev3 \
        -net nic,macaddr=DE:AD:BE:EF:B8:78 -net bridge,br=bridge0 \
	"$@"

# Close network bridge
sudo /home/david/.scripts/Virtual-Machines/qemu-bridge-ifdown.sh
