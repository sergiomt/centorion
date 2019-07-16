# How to configure VirtualBox

-------------------------------------------------------------------------------

## INSTALL VIRTUAL BOX GUEST ADDITIONS

If your CentOS image does not include VirtualBox Guest Additions then download the version of Guest Additions that matches exactly your installed VirtualBox version from [here](http://download.virtualbox.org/virtualbox/) rename it to VBoxGuestAdditions.iso and place it in the same directory as Virtualbox.exe is which for Windows typically is C:\Program Files\VirtualBox.

The easiest way to get VirtualBox Guest Additions is by mean of using the [vagrant-vbguest plugin](https://github.com/dotless-de/vagrant-vbguest).
Just install the plugin before you do vagrant up

`vagrant plugin install vagrant-vbguest`

See also [VirtualBox Guest Additions on CentOS 7.5](https://www.if-not-true-then-false.com/2010/install-virtualbox-guest-additions-on-fedora-centos-red-hat-rhel/).

To manully install or upgrade do:

```
sudo yum install gcc kernel-devel kernel-headers dkms make bzip2 perl
mkdir /media/VirtualBoxGuestAdditions
mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
cd /media/VirtualBoxGuestAdditions
./VBoxLinuxAdditions.run
```

The kernel-headers and kernel-devel must match exactly the version of your installed kernel.
In order to check this do:
`uname -r` 
and
`rpm -q kernel-devel`
If the versions don't match then `yum remove` kernel-devel and kernel-headers and `yum install`again with the exact version required.


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
```
sudo pvcreate /dev/sdb
sudo vgextend cl /dev/sdb
sudo lvextend -L+2G /dev/cl/swap
```

this will add 2Gb to the swap space.
