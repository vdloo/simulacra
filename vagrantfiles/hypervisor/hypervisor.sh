#!/bin/bash
#!/bin/bash
pacman -S libvirt virt-manager qemu dnsmasq bridge-utils openbsd-netcat ebtables firewalld vagrant --needed --noconfirm

# Configure firewalld
sed -i 's/FirewallBackend=nftables/FirewallBackend=iptables/g' /etc/firewalld/firewalld.conf
# also see https://bugzilla.redhat.com/show_bug.cgi?id=1688185
if echo 'dca05a90ca9c31fd436fe74c528fa134 /usr/lib/firewalld/zones/libvirt.xml' | md5sum -c; then
    sed -i "/<rule priority='32767'>/d" /usr/lib/firewalld/zones/libvirt.xml
    sed -i "/  <reject\/>/d" /usr/lib/firewalld/zones/libvirt.xml
    sed -i "/<\/rule>/d" /usr/lib/firewalld/zones/libvirt.xml
fi
systemctl start firewalld

# Configure libvirt
mkdir -p /home/libvirt/images
chown 0755 /home/libvirt/images
systemctl start libvirtd || /bin/true
virsh net-start default || /bin/true
virsh pool-destroy devstack || /bin/true
virsh pool-create pool.xml

sleep 5
vagrant plugin list | grep vagrant-libvirt || vagrant plugin install vagrant-libvirt
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up
