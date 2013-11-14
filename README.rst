Gene2Farm Winter School 2013
============================

The repository contains the Vagrant configuration files for the VM of the course

Requirements
------------

The virtual machine can only run on a **64bit compatible** system since most of the tools require 64bit instructions and therefore are compiled for this architecture.

If you are on Microsoft Windows and want to check if your machine 64bit capabilities, please have a look at `this post <http://superuser.com/questions/251014/how-to-check-whether-my-hardware-is-64-bit-capable-in-windows>`_.

To use the virtual machine the following tools are needed:

- Oracle VirtualBox - https://www.virtualbox.org/wiki/Downloads

- Vagrant - http://docs.vagrantup.com/v2/installation/index.html

- If you are on a Mac or linux just check if you have git installed.
  For Windows users: you need Git with ssh - http://git-scm.com/downloads


VM installation
---------------

Once you have all the required dependencies you can install the machine::

    git clone https://github.com/emi80/gene2farm.git
    cd gene2farm
    vagrant up

The configuration of the VM and the installation of all the software will take approximately half an hour, depending on your internet connection speed and your computer specifications. However, this is a one-time step that does only need to be repeated if you remove the machine (see below).


Updating VirtualBox Guest Additions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the versions of VirtualBox and VirtualBox Guest additions do not match you can get a message like the following::

    [default] The guest additions on this VM do not match the installed version of VirtualBox!" In most cases this is fine, but in rare cases it can cause things such as shared folders to not work properly. If you see shared folder errors, please update the guest additions within the virtual machine and reload your VM.

If you get this message run the following commands::

    vagrant plugin install vagrant-vbguest

This will install the Vagrant vbguest plugin which will take care of keeping VirtualBox Guest Additions updated. Then run the following command to reboot the machine and make the plugin do its work::

    vagrant reload

Since the VM has no graphical interface installed, you can safely ignore this message::

    Installing the Window System drivers ...fail!
    (Could not find the X.Org or XFree86 Window System.)
    An error occurred during installation of VirtualBox Guest Additions 4.3.2. Some functionality may not work as intended.

You then need to reboot the machine to apply the new Guest Additions::

    vagrant reload

The output of the command will be something like::

    ...
    [default] Booting VM...
    GuestAdditions 4.3.2 running --- OK.
    [default] Waiting for machine to boot. This may take a few minutes...
    ....


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


Using a shared folder between the host and the VM
-------------------------------------------------

The Vagrantfile already containes a line to configure a shared folder between the VM and the host machine. The configuration points to a ``data`` folder within the current folder in the host machine and creates a ``/data`` folder in the VM. 

The line is commented and looks like::

.. code-block:: ruby

    # shared folders
    # config.vm.synced_folder "data", "/data"

Just uncomment the second line to enable the shared folder. To apply the configuraton to the VM run::

    vagrant up

if the VM was stopped. Or::

    vagrant reload

if the VM was running.


Using X applications
--------------------

To access graphical application in the VM without installing any desktop environment you need an X server running in your host machine. If you are on a linux host system you can skip the whole section.

OSX
~~~

1. Install `XQuartz <http://xquartz.macosforge.org>`_. You can skip this if you are on OSX version up to 10.5.
2. Go to Applications -> Utilities
3. Launch the X11 app
4. Click on the Applications menu -> Terminal to open a new terminal window
5. Work from there


Windows
~~~~~~~

1. Install `Xming <http://www.straightrunning.com/XmingNotes>`_
2. Install `Putty <http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html>`_
3. Open XLaunch and select the following options:

 - Multiple windows -> next
 - Start no client -> next
 - Tick Clipboard in additional parameters -> next
 - FInish

4. Open Putty and connect with the following parameters:

 - hostname: 127.0.0.1
 - port: 2222
 - username: vagrant
 - password: vagrant
 - select SSH -> X11 and enable **X11 forwarding** 
