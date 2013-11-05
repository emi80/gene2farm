# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. For a reference of the available 
  # options, please see the online documentation at vagrantup.com.

  # the box
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  # shared folders
  # config.vm.synced_folder "data", "/data"

  # virtualbox custom configuration
  config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  # provisioninig
  config.vm.provision :shell, :path => "bootstrap.sh"

end
