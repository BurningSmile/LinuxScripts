#!/bin/bash
# purpose: This script is to automate the process for backing up all domains running on a node. This script will perform the following tasks:
# 1) Backup the xml files for each domain
# 2) Create a temporrary snapshot for the domain to write to while backing up the backing image.
# 3) live pivot the domain to the snapshot.
# 4) rsync the original disk image to the backup location
# 5) Blockcommit changes from the snapshot into the backing image
# 6) Live pivot the domain to the backing image
# 7) Delete the snapshot.
# USAGE: Run the script

# ------------------------------------------
# Variables
# ------------------------------------------
BACKUPPATH='/backup/vms'
BACKUPPATHXML='/backup/vms-xml'
TIMESTAMP=`/bin/date +%s`
SNAPSHOT_NAME=$TIMESTAMP
VM_FOLDER="/vms"

# ------------------------------------------
# Set up paths to binaries
#  ------------------------------------------
virsh='/usr/bin/virsh'
rsync='/usr/bin/rsync'
mkdir='/bin/mkdir'

# ------------------------------------------
# Don't edit anything below this line unless you know what you're doing!
# ------------------------------------------

# Create directory structure
mkdir -p $BACKUPPATH
mkdir -p $BACKUPPATHXML

# list running domains
list_running_domains() {
  virsh list --all | grep running | awk '{print $2}'
}

# List shutoff domains
list_shutoff_domains() {
  virsh list --all | grep shut | awk '{print $2}'
}

# Dump xml files to backup location
list_running_domains | while read DOMAIN; do
  virsh dumpxml $DOMAIN --migratable --inactive > $BACKUPPATHXML/$DOMAIN.xml
done

list_shutoff_domains | while read DOMAIN; do
  virsh dumpxml $DOMAIN --migratable > $BACKUPPATHXML/$DOMAIN.xml
done

# Create domain snapshot directories
list_running_domains | while read DOMAIN; do
  mkdir -p `echo $VM_FOLDER`/$DOMAIN/snapshots/`echo $TIMESTAMP`
done

# Snpapshot path & name variables.
MEM_FILE="snapshots/`echo $TIMESTAMP`/mem.qcow2"
DISK_FILE="snapshots/`echo $TIMESTAMP`/disk.qcow2"

# Snapshot running domains
list_running_domains | while read DOMAIN; do
  virsh snapshot-create-as \
    --domain $DOMAIN $SNAPSHOT_NAME \
    --diskspec vda,file=$VM_FOLDER/$DOMAIN/$DISK_FILE,snapshot=external \
    --memspec file=$VM_FOLDER/$DOMAIN/$MEM_FILE,snapshot=external \
    --atomic
done

# Rsync the disk images to the backup location
rsync -aL --sparse --delete --exclude=*/snapshots/$TIMESTAMP $VM_FOLDER/ $BACKUPPATH

# Blockpull snapshots to domains backing images
list_running_domains | while read DOMAIN; do
  virsh blockcommit $DOMAIN vda --active --pivot
done

# Delete temp snapshots.
list_running_domains | while read DOMAIN; do
  rm -rf `echo $VM_FOLDER`/$DOMAIN/snapshots/`echo $TIMESTAMP`
done

# Log date to logfile.
echo $(date) - Backup complete >> /var/log/backup-libvirt-domains.log
