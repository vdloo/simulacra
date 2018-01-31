#!/bin/bash
set -e

# Set up some VMs in my home lab. Uses terraform to start up qemu machines with macvtap networking.
# This script needs to run on another host than the hypervisor because the hypervisor can not
# talk directly with the guests because macvtap injects packets directly into the hardware
# interface. To discover the ip addresses of the created VMs the other host (the one that
# runs this script) must populate the arp cache (by either running nmap or arping) and then
# grep the mac addresses from the arp table.

HYPERVISOR="192.168.1.182"

ssh root@$HYPERVISOR systemctl start libvirtd << EOF
systemctl start libvirtd
systemctl start firewalld
virsh net-start default
EOF
sleep 3  # Giving the hypervisor some time to start up
ssh root@$HYPERVISOR virsh pool-destroy default
ssh root@$HYPERVISOR virsh pool-create pool.xml
ssh root@$HYPERVISOR << EOF
cd /root/code/projects/simulacra/terraform
terraform destroy -force
virsh list --all | grep grid | awk '{print$2}' | xargs -I {} virsh destroy {}
terraform apply -auto-approve
EOF

MAC_ADDRESSES=$(ssh root@$HYPERVISOR cat /etc/libvirt/qemu/grid*.xml | grep "mac address" | cut -d"'" -f2)

# warm ARP cache, discover all hosts on the network
# doing three passes to make sure we got them all
echo "Flushing and warming ARP cache"
ip -s -s neigh flush all
for i in {1..6}; do
    echo "Discovering hosts, sweep $i out of 6"
    nmap -sn 192.168.1.0/24 -n --send-ip -v0 -T5 --min-parallelism 100 --max-parallelism 256
    sleep 10
done

# Get IP addresses of all VMs
IP_ARRAY=()
for mca in $MAC_ADDRESSES; do
    IP_ARRAY+=($(arp -a -n | grep -v incomplete | grep $mca | awk -F"[()]" '{print $2}'))
done

node_count=1
for ip in "${IP_ARRAY[@]}"; do
    echo $ip
    ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$ip << EOF
    pacman -Syyu --noconfirm
    pacman -S screen --noconfirm --needed
    /usr/bin/screen -S reboot -d -m bash -c "test -f /root/id_rsa || ssh-keygen -q -N '' -f /root/.ssh/id_rsa; pacman -S jre8-openjdk-headless docker screen sudo ruby git rsync ntp puppet acl python2 python3 python-virtualenv python-virtualenvwrapper python-pip --noconfirm --needed; systemctl enable docker; ntpd -q; sleep 3; reboot"
EOF
    java -jar jenkins-cli.jar -s http://localhost:8090 delete-node grid$node_count || /bin/true
    java -jar jenkins-cli.jar -s http://localhost:8090 get-node grid0 | sed "s/1.2.3.4/$ip/g" | java -jar jenkins-cli.jar -s http://localhost:8090 create-node grid$node_count
    node_count=$((node_count + 1))
done

