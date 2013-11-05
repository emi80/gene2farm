Gene2Farm Winter School 2013
============================

The repository contains the Vagrant configuration files for the VM of the course

Requirements
------------

To use the virtual machine the following tools are needed:

- VirtualBox - https://www.virtualbox.org/wiki/Downloads

- Vagrant - http://docs.vagrantup.com/v2/installation/index.html

VM installation
---------------

Once you have all the required dependencies you can install the machine::

    git clone git://github.com/emi80/gene2farm.git
    cd gene2farm
    vagrant up

The configuration of the VM and the installation of all the software can take some time

Once the installation is completed you can access the VM with the following command::

    vagrant ssh

The software for the course can be found within the ``/soft`` folder.

