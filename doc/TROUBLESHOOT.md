# Troubleshooting

## Vagrantfile

In case you have made any change to Vagrantfile then validate it with:

`vagrant validate`

In case you need a full debug trace during VM creation you may use:

`vagrant up machine_name -- debug > vagrant_debug.log 2>&1`

For watching your SSH configuration use:

`vagrant ssh-config`

For trying to stablish an SSH connection with debug enabled use:

`vagrant ssh -- -vvv`

At Vagrantfile, set `vb.gui = true` enable the GUI of VirtualBox and see whether the VM is waiting for input on startup

## Grub

In case you need to change grub configuration, for example to edit boot command line, do:

`sudo vi /etc/default/grub`

Change the properties as required and then execute

`sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

`sudo grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg`

