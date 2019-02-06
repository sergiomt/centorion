# How to configure VirtualBox

-------------------------------------------------------------------------------

## INSTALL VIRTUAL BOX GUEST ADDITIONS

See [VirtualBox Guest Additions on CentOS 7.5](https://www.if-not-true-then-false.com/2010/install-virtualbox-guest-additions-on-fedora-centos-red-hat-rhel/).

Execute:

```
sudo yum install gcc kernel-devel kernel-headers dkms make bzip2 perl
mkdir /media/VirtualBoxGuestAdditions
mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
cd /media/VirtualBoxGuestAdditions
./VBoxLinuxAdditions.run
```

-------------------------------------------------------------------------------

## REBUILD THE BASE BOX

A VirtualBox base box is required at Vagrant file **vs.vm.box_url**

If a box is not available, it can be created using [Packer](https://www.packer.io/intro/index.html).

For building the base box, download [download Packer](https://www.packer.io/downloads.html) then change to the [/packer](packer) subdirectory of CentOrion.

Execute:

`packer build -var-file=variables-centos-7.5.json vagrant-centos.json`

This will create a base box name `vagrant-centos-75.box` that can be referenced from Vagrantfile.

Read more on Vagrant provisioners [here](https://www.packer.io/docs/provisioners/shell.html).

-------------------------------------------------------------------------------

## ADD SWAP SPACE

Some applications, i.e. Oracle need a swap space bigger than the default of 1279 Mb.

If you need to increase the swap space do the following:

With the VM halted, you must add a new virtual hard disk from Virtualbox by right clicking on the machine and then Configuration -> Storage.
Click on the icon of a hard drive with a + sign and add a new disk of 2Gb fixed size.

After adding the new hard disk do `vagrant up machine_name`

Once logged in type:

`sudo vgdisplay`
this will display the volume group information showing something like:
VG Name **cl**

Then execute
`sudo fdisk -l`
to list the available drives.
You should get in the list **/dev/hdb** or **/dev/sdb** depending on whether you are using spinning or solid states physical drives.

Now execute:
`
sudo pvcreate /dev/sdb
sudo vgextend cl /dev/sdb
sudo lvextend -L+2G /dev/cl/swap
`
this will add 2Gb to the swap space.
