# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # see the documentation at https://www.vagrantup.com/docs/index.html

  config.vm.boot_timeout = 150
  config.ssh.insert_key = false
  rsakey = File.read("vagrant-setup/keys/authorized_keys")
  
  # Replace default Vagrant insecure key with our own key and disable user+password login
  config.vm.provision "shell", inline: <<-EOC
    echo '#{rsakey}' >> /home/vagrant/.ssh/authorized_keys
    sed '/== vagrant insecure public key$/d' /home/vagrant/.ssh/authorized_keys
  EOC

  config.vm.define "CentOrion" , primary: true do |vs|

    # Every Vagrant virtual environment requires a box to build off of.
    # This is CentOS 7.3 + Puppet 4.8.1 + VirtualBox Additions 5.1.xx
    vs.vm.box = "vagrant-centos-73-x86_64-puppet"
    vs.vm.box_url = "vagrant-centos-7.3-48G.box"

    # Vagrant will need to login once with its own insecure_private_key in order to change it at guest's ~/.ssh/authorized_keys
    vs.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', "vagrant-setup/keys/centorion_openssh.key"]

    # The shell script that will execute once just after the VM is created
    vs.vm.provision "shell", path: "vagrant-setup/setup.sh"

    # Create a private network, which allows host-only access to the machine using a specific IP.
    vs.vm.network "private_network", ip: "192.168.101.110"
    
    # Create a public network, which generally matched to bridged network.
    # Bridged networks make the machine appear as another physical device on your network.
    # config.vm.network "public_network"

    vs.vm.provider "virtualbox" do |vb|
      # Enable the GUI of VirtualBox and see whether the VM is waiting for input on startup
      vb.gui = true
      # Use VBoxManage to customize the VM.
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "6144"]
    end
  end

  config.vm.define "openshift-master" , autostart: false do |ms|

    ms.vm.box = "vagrant-centos-73-x86_64-puppet"
    ms.vm.box_url = "https://github.com/CommanderK5/packer-centos-template/releases/download/0.7.3/vagrant-centos-7.3.box"

    ms.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', "vagrant-setup/keys/centorion_openssh.key"]
    ms.vm.provision "shell", path: "vagrant-setup/setup-openshift-master.sh"

    ms.vm.network "private_network", ip: "192.168.101.111"

    ms.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
  end

  config.vm.define "openshift-node1" , autostart: false do |nd|

    nd.vm.box = "vagrant-centos-73-x86_64-puppet"
    nd.vm.box_url = "https://github.com/CommanderK5/packer-centos-template/releases/download/0.7.3/vagrant-centos-7.3.box"

    nd.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', "vagrant-setup/keys/centorion_openssh.key"]
    nd.vm.provision "shell", path: "vagrant-setup/setup-openshift-node1.sh"

    nd.vm.network "private_network", ip: "192.168.101.112"

    nd.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080
  # config.vm.network :forwarded_port, guest: 22, host: 2210, id: "ssh", auto_correct: true

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Proxy configuration 
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxyuser:proxypasswd@XXX.XXX.XXX.XXXX:port"
    config.proxy.https    = "http://proxyuser:proxypasswd@XXX.XXX.XXX.XXXX:port"
    config.proxy.no_proxy = "localhost,127.0.0.1"
  end

end
