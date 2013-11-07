Gene2Farm Winter School 2013
============================

The repository contains the Vagrant configuration files for the VM of the course

Requirements
------------

To use the virtual machine the following tools are needed:

- Oracle VirtualBox - https://www.virtualbox.org/wiki/Downloads

- Vagrant - http://docs.vagrantup.com/v2/installation/index.html

- If you are on a Mac or linux just check if you have git installed.
  For Windows users: you need Git with ssh - http://git-scm.com/downloads

X Server
--------

To access graphical application in the VM without installing any desktop environment you need an installation of X in your host machine. You can skip the installation if:

- you already have an X Server installed
- your host operative system is Linux
- you have a Mac with OSX up to 10.5

OSX
~~~

1. Install `XQuartz <http://xquartz.macosforge.org>`_
2. Go to Applications -> Utilities
3. Launch the X11 app
4. Click on the Applications menu -> Terminal to open a new terminal window
5. Work from there


Windows
~~~~~~~

1. Install `Xming <http://www.straightrunning.com/XmingNotes>`_


VM installation
---------------

Once you have all the required dependencies you can install the machine::

    git clone git://github.com/emi80/gene2farm.git
    cd gene2farm
    vagrant up

The configuration of the VM and the installation of all the software will take approximately half an hour, depending on your internet connection speed and your computer specifications. However, thi is a one-time step that does only need to be repeated if you remove the machine (see below).


VM Usage
--------

Once the installation is completed you can access the VM with the following command::

    vagrant ssh

The software for the course can be found within the ``/soft`` folder.

In case you need to shutdown tha machine but you want to keep the configuration you have two options:

1. suspending the VM. You will be able to resume the VM quikly but the VM will use disk space while suspended::

    vagrant suspend

2. power off the VM. The VM will take more time to resume but there won't be any disk usage::

    vagrant halt

You can then resume the machine and continue working::

    vagrant up
    vagrant ssh

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
