# LinuxScripts
A collection of my various Linux scripts

To use any of the scripts clone the repo

```
cd /tmp
git clone https://github.com/BurningSmile/LinuxScripts.git
Make the script executable then run it
cd LinuxScripts
chmod +x script
./script
```

# Running the Windows10 vm script
```
For uefi support you need to do the following.[Standard Unix formating]
# install rpmextract as root from your distros package manager.
$ mkdir /tmp/rpm_extract && cd /tmp/rpm_extract
$ wget https://www.kraxel.org/repos/jenkins/edk2/edk2.git-ovmf-x64-0-20170410.b2624.gc571957.noarch.rpm
$ rpmextract.sh <Press tab for completion>
# mv -f ./usr/share/* /usr/share/ && cd && rm -rd /tmp/rpm_extract 

If you get a wget error please replace the end of the file with the new version from the URL.
Also please open a issue report so I can update the Readme file with the new link.

Please reference your distribution's documentation on qemu and kvm or read the official documentation here
https://www.linux-kvm.org/page/Documents
Someo other sources you may find usefull 
https://wiki.archlinux.org/index.php/KVM
https://wiki.archlinux.org/index.php/QEMU
```

# Please edit the scripts to use your username or other directories you want used!
