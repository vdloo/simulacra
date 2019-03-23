Vagrant setup for nested KVM
============================

This Vagrantfile creates a KVM VM in which you can run DevStack using libvirt. The VM has two network interface: eth0 for private networking with the Hypervisor, and eth1 for public networking. Note that the Hypervisor can not talk directly to the guest using the macvtap interface.

## Configuring the Hypervisor

On Archlinux, make sure that the file /etc/firewalld/firewalld.conf is changed back to contain:
```
FirewallBackend=iptables
```
See https://bbs.archlinux.org/viewtopic.php?id=241524

Install the required vagrant plugin(s):
```
vagrant plugin install vagrant-libvirt
```

## Starting the VM
```
export VAGRANT_DEFAULT_PROVIDER=libvirt
vagrant up
```
