#!/usr/bin/env sh
# Don't use the default mirrors for the initial upgrade
echo -e 'Server = http://mirror.nl.leaseweb.net/archlinux/$repo/os/$arch\nServer = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# Trust all signatures, currently broken out of the box. TODO: rm later
grep -q 'SigLevel    = Never' /etc/pacman.conf || sed -i -e 's/SigLevel    = Required DatabaseOptional/SigLevel    = Never/g' /etc/pacman.conf

rm -rf /etc/pacman.d/gnupg
pacman-key --init
pacman -Sy archlinux-keyring --noconfirm
pacman-key --populate archlinux

pacman -Sy --noconfirm

pacman -S ruby python3 python2 rsync git icu acl libmariadbclient nodejs base-devel iputils wget unzip screen xf86-video-vesa --noconfirm --needed

# Make sure the kernel is not upgraded on 'pacman -Syu' because otherwise we'd need to reboot
# yet again before docker will work inside the virtualized guest due to the right veth kernel module 
# not being able to be loaded.  Workaround for:
# docker: Error response from daemon: failed to create endpoint ... on network bridge: 
# failed to add the host (...) <=> sandbox (...) pair interfaces: operation not supported.
grep -q "IgnorePkg = linux" "/etc/pacman.conf" || sed -i '/\[options\]/a IgnorePkg = linux' /etc/pacman.conf 
