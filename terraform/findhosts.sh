#!/bin/bash
# Do not run this on the Hypervisor, it won't be able to 
# connect directly to the guests because of macvtap. Any
# other network card in the network should do though.
MATCHING_IPS=$(sudo nmap --max-retries 10 -sV -p 22 192.168.1.0/24 | grep "OpenSSH 7" -B 5 | grep report | awk '{print $NF}')

for ip in $MATCHING_IPS
do
    # Will print the IP and hostname of each host that 
    # looks like a host that we have spawned. Will 
    # contain other hosts with the same characteristics 
    # as well so be careful.
    printf "$ip "
    ssh -q -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no root@$ip hostname
done

