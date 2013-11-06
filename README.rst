Gene2Farm Winter School 2013
============================

The repository contains the Vagrant configuration files for the VM of the course

Requirements
------------

To use the virtual machine the following tools are needed:

- Oracle VirtualBox - https://www.virtualbox.org/wiki/Downloads

- Vagrant - http://docs.vagrantup.com/v2/installation/index.html


VM installation
---------------

Once you have all the required dependencies you can install the machine::

    git clone git://github.com/emi80/gene2farm.git
    cd gene2farm
    vagrant up

The configuration of the VM and the installation of all the software will take approximately half hour, depending on your internet connection speed and your computer specifications. However, thi is a one-time step that does only need to be repeated if you remove the machine (see `destroy`_).


VM Usage
--------

Once the installation is completed you can access the VM with the following command::

    vagrant ssh

The software for the course can be found within the ``/soft`` folder. In case you need to shutdown tha machine but you want to keep the configuration you have two options:

1. suspending the VM. It will be fast to recover your work but the VM will use disk space::

    vagrant suspend

2. power off the VM. The machine will take more time to boot again but ther won't be any disk usage::

    vagrant halt

You can then resume the machine and continue working::

    vagrant up
    vagrant ssh

.. _destroy:

When you don't need the VM anymore you can remove it from your system::

    vagrant destroy

More information can be found `here <http://docs.vagrantup.com/v2/getting-started/index.html>`_.

    Please note that all the ``vagrant`` commands should be run within the VM folder


VM configuration
----------------

The VM is configured by default with 1 cpu, 2G of ram and 16M of video memory. You can change the configuration by editing the following part of the Vagrantfile:

.. code-block:: ruby

    # virtualbox custom configuration
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", "1"]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--vram", "16"]
    end

Further information on how to configure the virtualbox provider for Vagrant can be found `here <http://docs.vagrantup.com/v2/virtualbox/configuration.html>`_.
